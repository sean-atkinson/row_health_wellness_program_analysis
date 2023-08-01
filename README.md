# Table of Contents
<a id='table_of_contents'></a><br>
[Project Summary](#section_1)<br>
[Part 1: Targeted Insights (SQL)](#section_2)<br>
[Part 2: Marketing Analysis (Excel)](#section_3)<br>

<a id='section_1'></a>
# Project Summary

> <i>Modeled after [Ro](https://ro.co/weight-loss/), a modern direct-to-patient healthcare company</i>

Established in 2016, Row Health is a cutting-edge insurance company that serves over 100,000 customers across the United States.

In 2019, they introduced the Wellness Reimbursement program. This initiative offers subsidies for various wellness products, such as probiotics, digestive enzymes, and stress relief aids, aiming to foster a holistic health approach among their customers.

In this project, I take on the role of a data analyst within the patient research team, whose priority is to understand the performance of this reimbursement program to answer ad-hoc questions and surface recommendations to the product and marketing teams towards their goals of acquiring customers and increasing brand awareness.

This project consists of four parts:
- <b>Part 1: Targeted Insights</b>
  * Using SQL, I offer up answers to questions from the claims department on things like the top hair-related products, states with the most claims, and the most frequent users of our reimbursement program.
 
- <b>Part 2: Marketing Analysis</b>
  * Leveraging Excel, I assess campaign performance for our marketing team focusing on customer acqusition and brand awareness. 

- <b>Part 3: FILL THIS IN</b>
  * ? 

- <b>Part 4: Recommendations & Next Steps</b>
  * Suggestions on things to take a look at going forward.

The data I'll be using is spread out across three tables and consists of information on customers, campaigns, and claims.

Here is the Entity Relationship Diagram for the data I'll be using:

<img width="750" alt="image" src="https://imgur.com/PvUzVJm.png">

You can view the data in greater detail [here](https://github.com/sean-atkinson/row_health_wellness_program_analysis/tree/main/data).

<a id='section_2'></a>
# Part 1: Targeted Insights (SQL)
[(Back to table of contents)](#table_of_contents)<br><br>
<b>Summary of Targeted Insights</b>:

<b>2020 Product claims</b>
- Hair Growth Supplements (347 claims per month) and Vitamin B+ Advanced Complex (249 claims per month) were our most claimed products.
- Interestingly, while Hair Growth Supplements saw a steady rise throughout the year, Vitamin B+ Advanced Complex claims peaked in the spring.

<b>Top hair products for June 2023 </b>
- Hair Vitamins Trio ($18K) and Hair Growth Supplements ($12K) had highest claim amounts.
- All other hair products didn't break the $1k mark. This mimicks the pattern for the year where Hair Vitamins Trio ($110k) and Hair Growth Supplements ($90k) are our top performers while Hair and Nail Wellbeing ($3.5K) and Hair Vitamins II ($459) lag behind by quite some distance.

<b>Claims and claim amounts by state in 2023</b>
- NJ has the most claims (3,964) and has claimed the highest amount ($479K).
- NJ has led both categories for every year on record.

<b>Christmas Day, 2022, which category had the highest covered amount: Hair supplements, Biotin supplements, or Vitamin B supplements?</b>
- Hair supplements ($570). Hair supplements were also the most covered item in terms of units (15).
- No Biotin supplements were covered on that day.

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

<b>Overall average percent reimburesement for prdocts that are either hair related and sold in NY or a supplement product</b>
- 61%.
- 61% is also the overall average reimbursement rate for all products.

<b>Overall average number of days between claims for customer with more than one claim</b>
- 258 days.

<b>The product most often bought as a second product for customers with more than one order</b>
- Vitamin B+ Advanced Complex (3,822 times).
- In terms of second purchases, Vitamin B+ Advanced Complex has outsold the #2 (Hair Growth Supplements) and #3(Detox + Debloat Vitamin) products on the list combined (3,822 vs 3,661)

<b>Technical Analysis:</b><br>
For this analysis, I used SQL and BigQuery. In regards to SQL, I used aggregation functions, window functions, joins, filtering, common table expressions (CTEs), and the QUALIFY clause to use row_number() to filter results.

You can find my SQL queries for the above and other insights [here](https://github.com/sean-atkinson/row_health_wellness_program_analysis/blob/main/sql/claims_department_queries.sql).

Here is an example of the query result I got to identify the most often purchased second product for customers who've made more than one purchase (with the help of the qualify clause):

<img width="750" alt="SQL query result" src="https://imgur.com/Xr54XHI.png">


<a id='section_3'></a>
# Part 2: Marketing Analysis (Excel)
[(Back to table of contents)](#table_of_contents)<br><br>
<a id='section_2_table_of_contents'></a>
## <b>Part 2 Table of Contents</b>
[2.1 Customer Acquisition](#section_2_1)<br>
[2.2 Brand Awareness](#section_2_2)<br>

<a id='section_2_table_of_contents'></a>
## <b>Part 2 Table of Contents</b>
[2.1 Customer Acquisition](#section_2_1)<br>
[2.2 Brand Awareness](#section_2_2)<br>


Briefly, this is why each metric was selected:

<b>Customer Acquisition</b>
- Signup rates - This directly relates to acquiring new customers.
- Cost per signup - Speaks to how efficiently we're acquiring new customers. T
- Channel effectiveness - Allows us to know how effective each channel is at acquiring new signups, enabling us to identify which channels should receive more or less investment.

<b>Brand Awareness</b>
- Click-through-rate (CTR) - The greater the rate, the greater the engagement with our content, a sign of brand recognition and interest.
- Impressions - The more your ad is shown, the greater the potential there is for people to see it and become aware of your brand.
- Cost-Per-Click (CPC) - This is a sign of user engagement and helps us to optimize our budget. Originally, cost-per-impression was looked at, but clicking an ad generally speaks to more engagement than just vieiwing an ad, which is crucial for brand awareness.

<a id='section_2_1'></a>
# 2.1 Customer Acquisition
[(Back to Section 2 table of contents)](#section_2_table_of_contents)<br>
<b>Signup Rates</b>
- Health For All  is the best performing campaign category with a 2.08% signup rate. This is largely due to our Email efforts which by themselves have a signup rate of 3.72%. 
- There's a considerable variation in signup rates across different categories. While Health For All has the highest signup rate at 2.08%, Golden Years Security has the lowest signup rate at a mere 0.001%.
- Social media is been our best performing platform with a 0.23% signup rate, Email follows closely at 0.20%.

<b>Cost per signup</b>
- 258 days.

<b>The product most often bought as a second product for customers with more than one order</b>
- Vitamin B+ Advanced Complex (3,822 times).
- In terms of second purchases, Vitamin B+ Advanced Complex has outsold the #2 (Hair Growth Supplements) and #3(Detox + Debloat Vitamin) products on the list combined (3,822 vs 3,661)

<a id='section_2_2'></a>
# 2.1 Brand Awareness
