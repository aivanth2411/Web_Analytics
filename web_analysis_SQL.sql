-- 1. Conversion rate by UTM source
SELECT 
	ws.utm_source,
	ROUND(COUNT(o.order_id) * 1.0 -- *1.0 để huyển sang dạng decimal
		/COUNT(ws.website_session_id),3) as conversion_rate 
FROM web_analytics.website_sessions ws -- tính cả sessions không có order
LEFT JOIN web_analytics.orders o
	ON o.website_session_id = ws.website_session_id
WHERE ws.utm_source IS NOT NULL
GROUP BY ws.utm_source
ORDER BY conversion_rate DESC;

-- 2. Number of sessions through funnel: homepage → product → cart → checkout → thank-you
SELECT pageview_url, COUNT(*) as sessions
FROM web_analytics.website_pageviews
GROUP BY pageview_url
ORDER BY COUNT(*) DESC;

SELECT 
	COUNT(DISTINCT CASE WHEN wp.pageview_url = '/home' THEN wp.website_session_id END) as homepage,
	COUNT(DISTINCT CASE WHEN wp.pageview_url = '/products' THEN wp.website_session_id END) as product,
	COUNT(DISTINCT CASE WHEN wp.pageview_url = '/cart' THEN wp.website_session_id END) as cart,
	COUNT(DISTINCT CASE WHEN wp.pageview_url IN ('/billing', '/billing-2') THEN wp.website_session_id END) as checkout,
	COUNT(DISTINCT CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN wp.website_session_id END) as thankyou
FROM web_analytics.website_pageviews wp;

-- 3. Number of sessions and unique users by campaign
SELECT
    COALESCE(utm_campaign, '(direct/organic)') AS utm_campaign,
    COUNT(DISTINCT user_id)                    AS users,
    COUNT(DISTINCT website_session_id)         AS sessions
FROM web_analytics.website_sessions
WHERE is_repeat_session = 1
GROUP BY utm_campaign
ORDER BY sessions DESC;

-- 4. Time on each page before clicking to the next page
WITH pageview_time as (
	SELECT 
		website_session_id,
		wp.pageview_url,
		created_at,
		LEAD(wp.created_at) OVER(
			PARTITION BY wp.website_session_id
			ORDER BY created_at) as next_pageview_time
	FROM web_analytics.website_pageviews wp
)
SELECT *, DATEDIFF(minute, created_at, next_pageview_time) as time_on_page
FROM pageview_time
ORDER BY website_session_id ASC;

-- 5. Compare attribution first-touch vs last-touch (utm_source)
WITH fist_touch_source as (
	SELECT 
		user_id,
		utm_source,
		ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at ASC) as rnk 
	FROM web_analytics.website_sessions
), 
last_touch_source as (
    SELECT 
        ws.user_id,
        utm_source,
        ROW_NUMBER() OVER (PARTITION BY ws.user_id ORDER BY ws.created_at DESC) as rnk
    FROM web_analytics.website_sessions ws
    INNER JOIN web_analytics.orders o
        ON ws.website_session_id = o.website_session_id
)
    SELECT 
        f.user_id,
        f.utm_source as first_touch,
        l.utm_source as last_touch
    FROM fist_touch_source f 
    JOIN last_touch_source l
        ON f.user_id = l.user_id
    WHERE f.rnk = 1 AND l.rnk = 1
    ORDER BY f.user_id;


-- 6. Cohort retention + lifetime value (LTV) by first session month.

-- 1) Cohort users based on first session
WITH cohort as (
	SELECT 
		user_id,
		MIN(created_at) AS first_session,
		DATEFROMPARTS(
            YEAR(MIN(created_at)), 
            MONTH(MIN(created_at)), 
            1
        ) AS cohort_month
	    FROM web_analytics.website_sessions
	    GROUP BY user_id
)
-- 2) Find orders and revenue of each user
, user_orders as (
	SELECT 
  	ws.user_id, 
  	o.created_at as order_at, 
  	DATEFROMPARTS(
            YEAR(o.created_at), 
            MONTH(o.created_at), 
            1
        ) AS order_month,
  	o.price_usd * o.items_purchased as revenue
  FROM web_analytics.website_sessions ws
  JOIN web_analytics.orders o
    ON o.website_session_id = ws.website_session_id
)
-- 3) Find time period between first session and first order 
, cohort_data as (
	SELECT 
		c.user_id,
		c.cohort_month,
		u.order_month,
		DATEDIFF(month, c.cohort_month, u.order_month) as month_number,
		u.revenue 
	FROM cohort c
	INNER JOIN user_orders u
		ON c.user_id = u.user_id 
	WHERE DATEDIFF(month, c.cohort_month, u.order_month) BETWEEN 0 AND 3
)
-- 4) Cohort users based on cohort month (time period between first session and first order)
, cohort_revenue as (
	SELECT 
		 cohort_month,
	    SUM(CASE WHEN month_number = 0 THEN revenue  END) AS month_0,
	    SUM(CASE WHEN month_number = 1 THEN revenue  END) AS month_1,
	    SUM(CASE WHEN month_number = 2 THEN revenue  END) AS month_2,
	    SUM(CASE WHEN month_number = 3 THEN revenue  END) AS month_3
	FROM cohort_data
	GROUP BY cohort_month
)

-- Cohort revenue
SELECT 
	cohort_month,
	ROUND(month_0, 2) AS month_0_revenue,
    ROUND(month_1 * 100.0 / NULLIF(month_0, 0), 1) AS month_1_pct,
    ROUND(month_2 * 100.0 / NULLIF(month_0, 0), 1) AS month_2_pct,
    ROUND(month_3 * 100.0 / NULLIF(month_0, 0), 1) AS month_3_pct
FROM cohort_revenue
ORDER BY cohort_month;
	
-- 7. Daily revenue & rolling 28-day average
WITH daily as (
	SELECT
		CAST(o.created_at AS DATE) as order_date,
		SUM(o.items_purchased * o.price_usd) as daily_revenue
	FROM web_analytics.orders o
	GROUP BY CAST(o.created_at AS DATE)
) 
SELECT 
	order_date,
	daily_revenue,
	ROUND(AVG(daily_revenue) OVER(
		ORDER BY order_date
		ROWS BETWEEN 27 PRECEDING AND CURRENT ROW
	),2) AS rolling_avg_28d
FROM daily
ORDER BY daily.order_date ASC;

-- 8. Net revenue by product (exclude refund). Ranking by net value
SELECT 
	p.product_id,
	p.product_name,
	SUM(o.items_purchased * o.price_usd) - COALESCE(SUM(oir.refund_amount_usd),0) as revenue
FROM web_analytics.orders o 
	JOIN web_analytics.products p ON o.primary_product_id = p.product_id
	LEFT JOIN web_analytics.order_item_refunds oir ON oir.order_id = o.order_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC;
