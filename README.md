# Row Health Wellness Program Analysis: 2019-2023

<img width="750" alt="A Tableau dashboard showing brand awareness metrics" src="https://imgur.com/wpncY5H.png">

Analyzing Row Health brand awareness metrics from 2019-2023. 

An interactive Tableau dashboard can be found [here](https://public.tableau.com/app/profile/sean.atkinson/viz/row_health_dashboards/BrandAwarenessDashboard).

# Table of Contents
<a id='table_of_contents'></a><br>
[Project Summary](#section_1)<br>
[Part 1: Targeted Insights (SQL)](#section_2)<br>
[Part 2: Marketing Campaign Analysis (Excel)](#section_3)<br>
[Part 3: Visualizations (Tableau)](#section_4)<br>
[Part 4: Recommendations & Next Steps](#section_5)<br>
[Addendum: Notes on the Marketing Campaign Analysis](#section_6)<br>

<a id='section_1'></a>
# Project Summary

> <i>Modeled after [Ro](https://ro.co/weight-loss/), a modern direct-to-patient healthcare company.</i>

Established in 2016, Row Health is a cutting-edge insurance company that serves over 100,000 customers across the United States.

In 2019, they introduced the Wellness Reimbursement program. This initiative offers subsidies for various wellness products, such as probiotics, digestive enzymes, and stress relief aids, aiming to foster a holistic health approach among their customers.

In this project, I take on the role of a data analyst within the patient research team, whose priority is to understand the performance of this reimbursement program to answer ad-hoc questions and surface recommendations to the product and marketing teams towards their goals of acquiring customers and increasing brand awareness.

This project consists of four parts:
- <b>Part 1: Targeted Insights</b>
  * Using SQL, I offer answers to questions from the Claims department regarding things like the top hair-related products, states with the most claims, and the most frequent users of our reimbursement program.
 
- <b>Part 2: Marketing Campaign Analysis</b>
  * Leveraging Excel, I assess campaign performance for our marketing team, focusing on customer acquisition and brand awareness, by selecting three metrics of interest for each.

- <b>Part 3: Visualizations</b>
  * With the aid of Tableau, I create a dashboard for the Marketing department to monitor brand awareness metrics on an ongoing basis.

- <b>Part 4: Recommendations & Next Steps</b>
  * Suggestions on things to take a look at going forward.

The data I'll be using is spread out across three tables and consists of information on customers, campaigns, and claims.

Here is the Entity Relationship Diagram for the data I'll be using:

<img width="750" alt="Row Health Entity Relationship Diagram" src="https://imgur.com/PvUzVJm.png">

You can view the data in greater detail [here](https://github.com/sean-atkinson/row_health_wellness_program_analysis/tree/main/data).

Also, a presentation on the main findings of this project can be found [here](https://github.com/sean-atkinson/row_health_wellness_program_analysis/blob/main/presentation/row_health_presentation.pdf).
<br>

<a id='section_2'></a>
# Part 1: Targeted Insights (SQL)
[(Back to table of contents)](#table_of_contents)<br><br>

<b>SUMMARY:</b>

<b>2020 Product claims</b>
- Hair Growth Supplements (347 claims per month) and Vitamin B+ Advanced Complex (249 claims per month) were our most claimed products.
- Interestingly, while Hair Growth Supplements saw a steady rise throughout the year, Vitamin B+ Advanced Complex claims peaked in the spring.

<b>Top hair products for June 2023 </b>
- Hair Vitamins Trio ($18K) and Hair Growth Supplements ($12K) had highest claim amounts.
- All other hair products didn't surpass the $1K mark. This mimics the pattern for the year where Hair Vitamins Trio ($110k) and Hair Growth Supplements ($90k) are our top performers while Hair and Nail Wellbeing ($3.5K) and Hair Vitamins II ($459) lag behind by quite some distance.

<b>Claims and claim amounts by state in 2023</b>
- NJ has the most claims (3,964) and has claimed the highest amount ($479K).
- NJ has led both categories for every year on record.

<b>Total customers with a platinum plan, and who signed up in 2023, or customers who signed up in 2022</b>
- 2,926.
- Unfortunately, only 3 of that 2,926 are platinum members who signed up in 2023.

<b>Customers with the most claims across all time (and total claims)</b>
- Eduardo Johnson (55)
- Marylee Rivera (55)
- Anthony Ford (54)
- Samuel Blount (54)
- Mark Cotton (54)
- Earl Healy (53)
- Charles Black (52)
- Robert Torres (52)
- Catherine Obrecht (52)

<b>Overall average number of days between claims for customer with more than one claim</b>
- 258 days.

<b>The product most often bought as a second product for customers with more than one order</b>
- Vitamin B+ Advanced Complex (3,822 times).
- In terms of second purchases, Vitamin B+ Advanced Complex has outsold the #2 (Hair Growth Supplements) and #3 (Detox + Debloat Vitamin) products on the list combined (3,822 vs 3,661).

<b>Technical Analysis:</b><br>
For this analysis, I used SQL and BigQuery. In regards to SQL, I used aggregation functions, window functions, joins, filtering, a CASE expression, common table expressions (CTEs), and the QUALIFY clause to use row_number() to filter results.

You can find my SQL queries for the above and other insights [here](https://github.com/sean-atkinson/row_health_wellness_program_analysis/blob/main/sql/claims_department_queries.sql).

Here is an example of me using the QUALIFY clause:
```sql
-- Identifying the most commonly ordered second product for customers who have made more than one claim
-- CTE to filter customers with more than one claim
WITH customers_multiple_orders AS (
    SELECT 
        *
    FROM 
        `rowhealth.claims` claims
    LEFT JOIN 
        `rowhealth.customers` customers ON claims.customer_id = customers.customer_id 
    QUALIFY 
        ROW_NUMBER() OVER (PARTITION BY claims.customer_id ORDER BY claim_date) = 2
    ORDER BY 
        1
)

-- Main query to calculate the number of claims for each product name 
SELECT 
    product_name, 
    COUNT(DISTINCT claim_id) AS num_claims
FROM 
    customers_multiple_orders
GROUP BY 
    1
ORDER BY 
    2 DESC;
```

And here are the top ten query results:
| product_name                    |   num_claims |
|:--------------------------------|-------------:|
| Vitamin B+ Advanced Complex     |         3822 |
| Hair Growth Supplements         |         1946 |
| Detox + Debloat Vitamin         |         1715 |
| Daily Greens Pouch              |          470 |
| Probiotics Formulation          |          322 |
| Essential Fatty Acid Supplement |          318 |
| Well Bundle Vitamins            |           79 |
| Oxytocin Supplement             |           62 |
| SuperYou Natural Stress Relief  |           26 |
| Nutrition Digestive Enzyme      |           24 |
<br>

<a id='section_3'></a>
# Part 2: Marketing Campaign Analysis (Excel)
[(Back to table of contents)](#table_of_contents)<br><br>

<b>SUMMARY:</b>

<b>CUSTOMER ACQUISITION</b>

<b>Signup rates (ratio of signups to impressions)</b>
- With a standout signup rate of 2.08%, Health For All has proven to be our top-performing campaign category, largely driven by our effective email initiatives, which have achieved a 3.72% signup rate within the campaign. 
- There's a considerable variation in signup rates across different categories. While Health For All has the highest signup rate at 2.08%, Golden Years Security has the lowest signup rate at a mere 0.001%.
- Social media is our best performing platform with a 0.23% signup rate, Email follows closely at 0.20%.

<b>Cost per signup (ratio of cost to signups)</b>
- #CoverMatters is the campaign category with the lowest cost per signup ($0.65). Health for All ($1.23) is second. Golden Years Security has the highest cost per signup at $176.73.
- Social Media ($2.25) and Email ($4.04) are our best platforms. TV is by far our worst, with a cost per signup that was 366% higher than social media’s.

<b>Signups by channel (new users per platform)</b>
- Social media, with 7,610 signups, brought in 85% more than Email, which was the second most.
- TV is the platform with the least number of total signups, only managing to bring in 494 signups. This, coupled with its high cost per signup ($10.48) and low signup rate (0.08%), suggests that TV is the least effective platform for customer acquisition.<br> 

<b>BRAND AWARENESS</b>

<b>Click-through-rate (ratio of clicks to impressions)</b>
- In terms of platforms, Email performs the best with a 16.71% click-through-rate (CTR), 94% higher than the next closest platform (Social Media at 8.62%). TV has a 0% CTR.
- The Family Coverage Plan category has a CTR of 0%, indicating no clicks, despite 1.1M impressions. This is something that needs to be looked into further, since it's highly unusual.

<b>Impressions (total times an ad or promotional content is viewed)</b>
- Tailored Health Plans, #HealthyLiving, Preventive Care News and Family Coverage Plan are the only campaign categories to surpass 1M impressions.
- Health for All has the lowest total impressions of any campaign category (170K), yet has only 182 fewer signups than our best performing campaign category.
- Social Media and SEO have been our best channels for impression at 3.3M AND 3.2M respectively. TV lags behind everyone with 600K.

<b>Cost-per-click (ratio of cost to clicks)</b>
- For campaigns that have recorded at least one click, email is our best platform with a cost-per-click (CPC) of $0.05, social media is next at $0.06.
- SEO and TV are our worst. SEO has a CPC of $0.09. TV has not recorded a single click. 

<b>Technical Analysis:</b><br>
For this section, I used SQL and BigQuery to create a marketing campaign dataset. 

As part of the data preparation, I created derived columns for metrics that didn't pre-exist within the data: number of signups, signup rate, cost-per-signup, click-through rate, and cost-per-click.

In Excel, I used calculated fields because of an issue with non-weighted metrics. Additionally, I utilized Pivot Tables, conditional formatting and statistical analysis to analyze and summarize my insights for the marketing team. 

Here are examples of the pivot tables I used for customer acquisition insights:

<img width="750" alt="Excel pivot table showing signup rates, cost per signup, total and total signups on the campaign category and channel level" src="https://imgur.com/DLT1f6g.png">

You can find more detailed analysis in [this downloadable Excel workbook](https://github.com/sean-atkinson/row_health_wellness_program_analysis/blob/main/excel/row_health_marketing_workbook.xlsx).

You can find the SQL code for the dataset I created in BigQuery [here](https://github.com/sean-atkinson/row_health_wellness_program_analysis/blob/main/sql/marketing_campaigns_table.sql).
<br>

<a id='section_4'></a>
# Part 3: Visualizations (Tableau)
[(Back to table of contents)](#table_of_contents)<br><br>

<b>SUMMARY:</b>

<b>Cost-per-click</b>
- The two box and whisker plots with the widest spreads within their boxes, Compare Health Plans and Summer Wellness Tips, also did poorly in terms of impressions. This might speak to a lack of data or understanding of the target market, or a lack of understanding of who the target market is.
- The outlier value for the #InsureYourHealth campaign ($1.35) is so extreme that it should be assessed further. It’s 2,107% more than the Social Media channel average (which is where the campaign ran).

<b>Technical Analysis:</b><br>
For this section, I used Tableau exclusively to create a brand awareness dashboard. My data came from the marketing campaign dataset I created for my Excel analysis.

My Tableau dashboard incorporates KPIs, filters, tables, bar charts, and box-and-whisker plots.

Here is a peek at what my dashboard looks like:

<img width="750" alt="A Tableau dashboard showing brand awareness metrics" src="https://imgur.com/wpncY5H.png">

An interactive version of the above Tableau dashboard can be found [here](https://public.tableau.com/app/profile/sean.atkinson/viz/row_health_dashboards/BrandAwarenessDashboard).

A copy of my Tableau workbook can be found [here](https://github.com/sean-atkinson/row_health_wellness_program_analysis/tree/main/tableau).
<br>

<a id='section_5'></a>
# Part 4: Recommendations & Next Steps
[(Back to table of contents)](#table_of_contents)<br><br>
- <b>Prioritize High-Performing Campaigns and Platforms:</b> Given the strong performance of the Health For All campaign and email marketing efforts, consider increasing the budget for these initiatives by 15-20% (a percentage high enough to see results, but low enough in terms of spend, $3.3K on the high end, to be sufficiently cautious). Keep monitoring KPIs to ensure they campaigns continue to have strong ROI.
- <b>Think About Leveraging Social Media for Customer Acquisition and Brand Awareness:</b> Social media has demonstrated strong performance in several metrics.  That being said, [we’re in tumultuous times when it come to social media marketing](https://econsultancy.com/social-media-advertising-2023-trends-predictions/?ssp=1&setlang=en-CA&safesearch=moderate). Perhaps caution is the better part of valour here. It might be best to experiment with increasing social media budget by 10% for the next quarter while closely monitoring customer acquisition and brand awareness metrics.
- <b>Reevaluate Low-Performing Strategies:</b> TV has shown poor performance on every metric examined. Reduce its budget by 25% next quarter. Reallocate those resources to high-performing channels Email and Social Media. While it’s a significant decrease, it’s not the complete abandonment of this channel. We can re-evaluate at the end of the quarter.
- <b>Expand Email Marketing for Engagement:</b> Experiment with A/B testing by sending half of the target group 15-20% more emails for 30 days (a modest increase but enough to produce a noticeable result if there is an impact). Compare customer acquisition and brand awareness metrics at the end of the test.
- <b>Investigate the Family Coverage Plan Category:</b> It's perplexing that we’ve had over 1 million impressions without a single click. There’s a high possibility of an internal issue. Potential culprits include problems with event tracking, attribution, or data upload. Engaging our developers and data team for an in-depth examination of this anomaly is essential.
- <b> Improve Data Quality and Include Other Dimensions:</b> Add revenue to calculate ROI. Add customer-specific dimensions (plan, state, signup platform) to better customize campaign recommendations. Investigate how run time affects KPIs.
<br>

<a id='section_6'></a>
# Addendum: Notes on the Marketing Campaign Analysis
[(Back to table of contents)](#table_of_contents)<br><br>
With regards to the marketing campaign analysis, please note that the 24 most recent campaigns have incomplete data. They're currently missing total signups, signup rate, and cost per signup. 

As a result, only 33 out of the 57 campaigns have complete data.

Given that the missing data did not prevent meaningful analysis due to the availability of complete records for over half of the campaigns, I proceeded with the data available. However, I kept the potential bias in mind during my analysis and acknowledge my insights and recommendations may have been skewed as a result.

Potential future solutions for this are:
- Data imputation (based on past performance of similar campaigns, mean, median, or mode)
- Requesting the implementation of new/improved data recording procedures
- Predictive modelling
