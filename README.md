Customer Segmentation using RFM Analysis

Syntecxhub Data Analysis Internship · Week 2 · Project 1 · Maryam T Abu

I segmented 18,484 online customers of a bike retailer by Recency (how recently they bought), Frequency (how often) and Monetary value (how much they spent). Then I described each group and recommended a marketing action for each one.

Tools: Excel (data check and CSV export) · SQL Server (cleaning, RFM metrics, scoring, segments) · Power BI (dashboard)
Data: Microsoft's AdventureWorks sample data, a fictional company. It covers 60,398 online order lines from July 2005 to July 2008, plus the RFM segment table provided with the task.

Dashboard

Overview Segments and actions

Key findings
Churn risk is the priority. 5,998 customers (32.4%) bring 55.7% of revenue, but they last ordered 288 days ago on average.
Revenue is concentrated. The top 10% of customers bring 40.3% of revenue.
Loyal customers are few but valuable. They are 3.3% of customers and 13.5% of revenue, spending $6,420 each over 3.6 orders on average.
New and growing customers rarely come back. They are 46.2% of customers, but average just 1.4 orders each.
Lost customers barely spent. 3,323 customers (18%) brought in only 0.5% of revenue, and half of them spent under $40.
Loyalty depends on how long customers have been around. 91% of customers who joined before July 2007 bought again, against 15% of those who joined after. Australia looks most loyal partly because 53% of its customers joined early (US: 21%). But even among newer customers, 40% of Australians returned against 7% in the US.
The US has the most customers but the weakest loyalty. It has 7,819 customers, but only 3 are Loyal, and 78% bought just once. France has the top 20 spenders (about $13K each over 5 to 6 orders), but its typical customer spent just $98.
Recommendations
Group	Action
Churn risk	Win-back emails with personal offers. Start with At Risk (1,808 customers, 26.9% of revenue).
New and growing	A second-order discount or bundle to turn first-time buyers into repeat buyers.
Loyal and Champions	VIP rewards, early access to new bikes and a referral programme.
Lost	Low-cost automated emails only. No paid budget.
United States	Follow up after the first order and focus on bike buyers. Customers whose first order included a bike came back more often (38% against 28%).

Success measure: fewer customers moving into Churn risk and Lost each quarter, and more second orders from new customers.

How I did it
1. Excel: check and export
Opened the FactInternetSales sheet and checked the key columns: CustomerKey, OrderDateKey, SalesOrderNumber and SalesAmount.
Saved it as CSV (UTF-8) to import into SQL Server.
2. SQL Server: clean, calculate, segment (sql/)
File	What it does
01_rfm_customers.sql	Collapses 60,398 order lines into one row per customer: last order date, days since last order (counted from 1 Aug 2008), number of distinct orders, and total sales
02_rfm_scores.sql	Scores each customer 1 to 5. Recency and Monetary use NTILE(5). Frequency uses fixed steps (1, 2, 3, 4 and 5 or more orders), because 63% of customers ordered once
03_segment_lookup.sql	Loads the RFM segment table (125 scores, 11 segments) with each segment's description, marketing action and group
04_rfm_view.sql	Creates vw_rfm_customers: one row per customer with score, segment, group and country. Power BI reads from this view

Checks I ran: 60,398 lines, 27,659 orders, 18,484 customers and $29,358,677.89 in sales after import. Every customer received a segment.

3. Power BI: dashboard

Measures for customers, revenue, % of customers, % of revenue, average days since last order, churn-risk revenue share, loyal share and top-10% revenue share. A country slicer filters every page.

Data quality notes
No blanks in key columns, no duplicate order lines, and no zero or negative sales.
Tax and freight were excluded from revenue.
The RFM table listed scores 231, 241 and 251 under two segments. I kept them as About To Sleep, so no customer was counted twice. I also made the segment names consistent between the two sheets.
Accessories were only sold from July 2007, which is why newer customers often look low-value.
July 2008 is incomplete, with no bike sales at all, so the data was cut off mid-month.
Every order ships in exactly 7 days, so delivery couldn't be analysed.
The country codes in SalesTerritoryKey (1 to 5 are US regions) were mapped to country names.
No customer names, emails or addresses were used. Customers are identified by CustomerKey only.
Limitations
This is sample data about a fictional company. The project shows the method, not real business results.
Newer customers have had less time to reorder, so their loyalty looks lower.
The data shows what customers did, not why. The recommendations for the US and Australia are things to investigate.
