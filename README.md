
View full Power BI dashboard [here](https://app.powerbi.com/view?r=eyJrIjoiOWNlZGYwMjMtZGVhOS00MmIyLTlkMzgtZWQxZDc1ODgyNDI2IiwidCI6ImJlODMyOWE3LTcyMTgtNDlhMy05YWMxLWQ3Yjk1NDU2M2YzOSIsImMiOjEwfQ%3D%3D).
## About Dataset
This dataset is provided by [Xom Dataset](https://dataset.xomdata.com/), a community platform for practicing SQL. The dataset simulates web analytics data for Maven Fuzzy Factory, an e-commerce company specializing in stuffed animals. It covers 6 tables, including orders, order_items, order_item_refund, products, website_sessions, website_pageviews, within the time frame 2012 - 2015. 

In this project, I connected DBeaver to Xom Dataset's domain directly to pull the schema and query the data. Using **SQL** (JOIN, CTEs, Window Functions) and **Power BI** (DAX), I built a dashboard to track traffic, conversion, and revenue trends, then translated patterns in the data into business insights and recommendations.

Link to the dataset: [web_analytics](https://dataset.xomdata.com/datasets/schema/web_analytics)
### 🔗 Data Structure & ERD (Entity Relationship Diagram)

<p align="center">
<img width="1206" height="784" alt="Web_analytics" src="https://github.com/user-attachments/assets/949ad723-4c04-412b-b23b-2a43ee1f5c33" />

- `orders`: Order-level records, including order date, price, and linked session ID.
- `order_items`: Details per order, including product, quantity, price.
- `order_item_refunds`: Refunded items, including refund amount and refund date.
- `products`: Product catalog, including product name and date launched.
- `website_pageviews`: Page-view events, including URL and timestamp per session.
- `website_sessions`: Session data, including UTM source/campaign, device type, and session start time.
  
## 📂 Project Background
The analysis is structured around three core areas:
- **Overall Web Performance**: Evaluate total and month-over-month trends in sessions, page views, and revenue to identify key patterns and highlight where optimization is needed.
- **Acquisition & Conversion**: Analyze conversion rate trends and customer funnel  to identify which UTM sources and channels drive the most efficient traffic, and which steps in the customer journey underperform and need further investigation.
- **Revenue & Retention**: Examine cohort revenue, cohort retention, daily revenue, and 28-day rolling average revenue to assess whether the business is successfully acquiring and retaining customers, and to identify seasonal patterns.

## 📝 Executive Summary

### Overview of Findings

- **Overview:** Sessions and revenue follow a strong seasonal pattern, peaking each November–December and dropping sharply in January. Desktop drives most conversions while the mobile funnel's biggest weak point is the Product-to-Cart step.
- **Acquisition:** Conversion rate increased overtime , indicating improving traffic quality rather than just growing volume. Gsearch dominates traffic share, but bsearch converts at a slightly higher rate.
- **Revenue:** Cohort retention and rolling average analysis show a mild dip each December despite November spikes. This notions the need for cross-sell and seasonal re-engagement tactics.

<table style="width: 100%;">
  <tr>
    <td style="width: 33.33%; text-align: center;">
      <img width="523" height="302" alt="{B7B32F34-91DD-49E7-BB9F-26ECE10EEF72}" src="https://github.com/user-attachments/assets/490af81b-a378-4284-b7e9-33fbfd0e6af6" alt="Dashboard 1" width="100%">
      <p><i>Overview</i></p>
    </td>
    <td style="width: 33.33%; text-align: center;">
      <img width="524" height="299" alt="{535FD49A-CDB6-4FE3-A502-8C57417CD9CF}" src="https://github.com/user-attachments/assets/d0306902-4ada-4fea-8989-f687f03027a0" alt="Dashboard 2" width="100%">
      <p><i>Acquisition & Conversion</i></p>
    </td>
    <td style="width: 33.33%; text-align: center;">
      <img width="522" height="297" alt="{D93CF052-96A8-4DCB-8FE5-04B4142734DD}" src="https://github.com/user-attachments/assets/d59e95c3-f6a0-4ceb-a1c7-44275b01733f" alt="Dashboard 3" width="100%">
      <p><i>Revenue & Retention</i></p>
    </td>
  </tr>
</table>

## 👀 Insights Deep Dive

### Overview
**Revenue and Session Trend**

Traffic consistently peaks around December in 3 years witnessed, which is expected for an e-commerce business driven by holiday shopping. Specifically:
- Sessions grew steadily from 2K (Jan 2012) to a peak of 14K (Nov 2012), then dropped sharply to 6K in Jan 2013.
- The similar cycle repeated over the next two years, with sessions climbing to 30K in Dec 2014 before falling to 15K in Jan 2015.
Although this is a typical post-holiday seasonal pattern, further investigation into specific reasons (e.g. product quality) should be executed. In addition, the company can soften this slump by applying cross-sell/upsell campaign to retain old customers.

**Total Sessions by Device**

- Desktop leads in both traffic share and conversion efficiency: Desktop accounts for ~70% of total sessions with an 8.5% conversion rate, while mobile makes up the remaining ~30% and converts at just 3.1%.
- Since mobile underperforms even after accounting for its smaller traffic share, this points to friction in the mobile experience itself (page load speed, checkout flow, UI), not simply a traffic mix issue.

 ***Mobile Funnel***

| Step      | % from previous step | Definition                                   |
| --------- | -------------------- | -------------------------------------------- |
| Product   | 100%                 | Baseline                                     |
| Cart      | 28.7%                | % of Product viewers who reach Cart          |
| Checkout  | 42.1%                | % of Cart sessions who reach Checkout        |
| Thank you | 54.1%                | % of Checkout sessions who complete purchase |

- The mobile funnel showed that the largest drop off was rom the Product to Cart step, indicating issues with product showcase (e.g. UX/UI, loading errors) that need further investigation. 
- Meanwhile, Cart to Checkout and Checkout to Thank-you phase retention rate was high (> 40%), indicating a smooth customer journey that needs to maintained in the future. 

**Page Views by URL**
- The products page receives the highest number of page views, suggesting most users land there directly rather than starting from the homepage. This pattern is sensible as most traffic is driven by paid search ads.
- "The Original Mr. Fuzzy" is both the most viewed product and the top revenue driver, generating roughly $1,867K (about 73%) of the $2,542K total revenue.
- As revenue is heavily dependent on this product, there's a need to diversify revenue beyond one single SKU, while increasing the inventory reliability for this product to avoid scarcity and decrease in revenue. 
## Acquisition

**Conversion Rate Trend Over Time**

- The average conversion rate is 6.83%. Conversion rate shows a gradual upward trend across the period, with the highest increase between Quarter 4 2012 and Quarter 2013, which reflects the overall seasonal pattern. 
- This suggests the site is not just driving more traffic; the traffic is also converting increasingly well over time.

**Sessions vs. Conversion Rate by UTM Source**

*UTM Source: the parameter added into the URL to track the exact origin of web traffic*.
The number of website session from gsearch (Google Ads) wasn't proportional with conversion rate. 
- Total Conversions: gsearch (Google Ads) drives roughly 5x the sessions of bsearch (Bing Ads) and about 30x that of socialbook. Also, gsearch gained the highest traffic in both first touch and last touch step of all 3 channels. 
- Conversion Rate: However, bsearch converts at 7.2% while gsearch's only 6.8%.
To drive into conclusion which source is more efficient, the team should compare cost per click (CPC) and cost per acquisition (CAC) across channels to confirm whether bsearch's higher conversion rate also translates into better ROI, or whether gsearch is still more cost-efficient. 

**Customer Funnel** 

|Step|% from previous step|Definition|
|---|---|---|
|Product|100%|Baseline|
|Cart|36.35%|% of Product viewers who reach Cart|
|Checkout|54.83%|% of Cart sessions who reach Checkout|
|Thank you|62.07%|% of Checkout sessions who complete purchase|

- **Biggest drop off: Product to Cart (63.65% of viewers never add to cart).** Possible drivers for this might include price sensitivity, cross site comparison shopping, or vague CTA. To confirm the actual reason, there should be further research such as on site surveys, heatmaps, or session recordings.
- **Second notable drop off: Cart to Checkout (45.17%).** Possible drivers include unexpected costs revealed late (shipping or tax), a complicated checkout flow, or a required account creation step.
→ To validate these hypotheses before investing in a redesign, we need to prioritize UX research, including heatmaps and A/B tests on the cart and checkout pages.
### Revenue

**Daily Revenue & 28 Day Rolling Average**
- The 28 day rolling average shows steady growth from mid 2013 through mid 2015, with a mild dip each December despite daily revenue spikes in November across all three years, consistent with the seasonal pattern seen in overall sessions.
- We need to identify if this is simply a dup after a seasonal spike or a retention issue, in which customers who bought once for the holidays don't return. Methods that can be used are: observing the repeat purchase rate after December, or comparing cohort retention between seasons.

**Cohort Revenue (First 3 Months)**
- **Month 0 revenue:** Early cohorts (2012 to H1 2013) generated modest Month 0 revenue ($2,999 to $17,867), while cohorts from late 2013 onward show substantially higher Month 0 revenue ($25K to $182K), reflecting overall business growth.
- **Retention (Month 1 to 3, % of Month 0):** Month 1 retention fluctuates between roughly 8% and 14% across cohorts with no clear sustained upward trend. Month 2 and Month 3 retention decline further and remain volatile even in later cohorts.
- Because stuffed animals are a low frequency, often gift driven purchase, low repeat purchase rates are expected here and should not be judged by the same bar as subscription or FMCG products.
- Therefore, rather than chasing traditional retention metrics, focus on cross sell within a single visit, seasonal or gifting re engagement (birthdays, holidays), and referral programs, tactics better suited to this purchase pattern.

## ✨ Recommendations
Based on the insights and findings above, we would recommend the business to consider the following:

**1. Prioritize post-campaign services to avoid seasonal revenue slump**: Sessions and revenue consistently spike in November–December and drop sharply in January across all three years. Implementing cross-sell/upsell campaigns and seasonal re-engagement tactics right after the holiday peak can help retain customers and soften the post-holiday slump.

**2. Minimize dependence on one SKU**: The business should diversify its product mix while also strengthening inventory reliability for "The Original Fuzzy"  to avoid stockouts and revenue loss.

**3. Conduct research on customer funnel, between Product and Cart steps; focusing on mobile device**: This is the largest drop-off point in the funnel overall (63.65% of viewers never add to cart), and it's notably worse on mobile, pointing to friction in the mobile experience. We can use heatmaps and on-site surveys to pinpoint whether the cause is UX/UI, page load speed, or unclear CTAs.

**4. Identify which searching channel drives the best traffic**: There should be a CPC/CAC comparison across channels to confirm whether gsearch's traffic volume still makes it the most cost-efficient channel, or if bsearch delivers better ROI.
