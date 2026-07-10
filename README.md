# Kimia Farma Performance Analysis: Sales, Customer, and Inventory

## 1. Project Background

### 1.1 Business Context

Kimia Farma retail chain operates branches across multiple provinces in Indonesia and has accumulated transaction data from January 2020 to December 2023. As the business expands, management requires a comprehensive understanding of sales performance, customer behavior, inventory availability, and regional market penetration to support strategic decision-making.

Using historical transaction, product, branch, and inventory data, this project aims to identify opportunities to improve operational efficiency, strengthen customer retention, reduce lost sales caused by stock shortages, and uncover potential markets for future expansion.

## 1.2 Business Questions

This analysis addresses the following business questions:

1.	How has sales performance evolved between 2020 and 2023?
2.	Which products and product categories contribute most to revenue and profit?
3.	How do branches and provinces compare in terms of sales performance?
4.	Are there underserved markets with high expansion potential?
5.	How effective is the company's customer retention?
6.	Are current inventory levels sufficient to support customer demand?
7.	What business actions could improve revenue growth and operational efficiency?

## 2. Data Preparation & Data Structure

### 2.1 Data Sources

The analysis was conducted using four relational tables stored in Google BigQuery.

| Table |	Description |
| --- | --- |
| final_transaction |	Transaction history including transaction date, branch, customer, product, selling price, discount, and customer rating |
| product |	Product master containing product names, categories, and standard prices |
| branch |	Branch information including location, branch category, and branch rating |
| inventory |	Current inventory snapshot showing stock availability for each product at each branch |
| *demografi | The record of population by province | 

The dataset covers transactions from January 2020 to December 2023.

*is the dataset from Badan Pusat Statistik (external source)

### 2.1 Data Cleaning & Preparation

The following preparation steps were performed before analysis:

- Removed duplicate records where applicable.
- Validated primary and foreign key relationships between tables.
- Standardized data types for dates, prices, and identifiers.
- Calculated net sales after discounts.
- Joined transaction, product, branch, and inventory tables into an analytical dataset.
- Aggregated sales data by month, branch, province, product, and customer.
- Calculated customer-level metrics including repeat purchase behavior and returning customer rate.
- Derived inventory coverage metrics using recent average daily sales.

### 2.3 Key Metrics

The following KPIs were developed for business analysis:

Sales Performance

- Gross Sales
- Net Sales
- Gross Profit
- Monthly Sales Growth
- Sales Contribution (%)

Customer Analytics
	
- Total Customers
- Returning Customer Rate
- Repeat Purchase Rate
- Customer Revenue Contribution
- Average Customer Rating

Branch Performance

- Net Sales per Branch
- Sales per Province
- Sales per Million Residents
- Average Branch Rating

Inventory

- Current Inventory
- Daily Sales Velocity
- Inventory Coverage Days
- Potential Revenue Loss from Stockouts

### 2.4 Data Model

The project uses a star-schema design centered around the Transaction table.

1. Fact Table
   - final_transaction

3. Dimension Tables
   - Product
   - Branch
   - Inventory
     
<p align="center">
<img width="300" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/d31db543d598e8cbde5f02c3a5e1c5332fff14b5/star%20schema.png" />
<img width="300" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/d31db543d598e8cbde5f02c3a5e1c5332fff14b5/tabel%20analisis.png" />

## 3. Executive Summary

- Analysis of nearly four years of pharmacy retail operations shows a stable business with diversified product sales, improving customer retention, and consistent branch performance. Sales remained relatively stable throughout the analysis period with limited monthly variation, indicating predictable customer demand.
- Product revenue is well diversified, reducing dependence on any single product category or individual product. At the branch level, sales performance is highly consistent across provinces, suggesting that the company's operating model scales effectively across different markets.
- Customer retention has strengthened over time, with the returning customer rate increasing from 37.74% in 2021 to 60.57% in 2023. In addition, the top 10% of customers contribute approximately 45% of total revenue, highlighting the importance of retaining high-value customers.
- Inventory analysis identified operational improvement opportunities. A total of 201 product-branch combinations experienced stockouts despite ongoing demand, representing an estimated Rp707 million in potential gross revenue loss over seven days.
- Finally, geographic analysis indicates that several densely populated provinces remain underpenetrated despite their large consumer base, while three provinces currently have no branch presence. These findings suggest opportunities for both operational improvements and long-term market expansion.

## 4. Deep Analysis

### 4.1 Sales Growth Remained Stable Throughout 2020–2023

<p align="center">
<img width="1000" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/217f4e1b501980af50b8a6ccf2e52879465a0e5e/Sales%20Trend.png" />

Net sales showed steady growth from January 2020 to December 2023, with a monthly coefficient of variation (CV) of only 2.38%. Annual CV values also remained low, ranging between 2% and 3%.
This indicates that sales performance was relatively consistent throughout the period, with limited month-to-month fluctuations. The absence of significant spikes or declines suggests that demand is not heavily influenced by seasonality, allowing the business to maintain predictable sales performance over time.

### 4.2 Product Revenue Is Well Diversified

<p align="center">
<img width="800" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/9e8db74cc22d8e39b3deed0fb3de38b232db110d/Product%20Sales%20%26%20Profit.png" />

Sales performance across the eight product categories is relatively balanced. The highest-performing category contributed 17.13% of total net sales, while the lowest contributed 8.06%.
Profit contribution closely mirrors sales contribution across all categories, indicating a consistent margin structure throughout the product portfolio.

At the individual product level, net sales show a higher level of variation (CV = 55%) across 150 products. However, the top-selling product contributed only 1.28% of total net sales, suggesting that revenue is distributed across a broad range of products rather than concentrated in a small number of best sellers.

Overall, the product portfolio appears well diversified, reducing the company's dependence on any single product or category.

### 4.3 Revenue Is Concentrated in a Limited Number of Provinces

<p align="center">
<img width="1000" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/2fe5736944bda9f0e0dc00aded9f70050f3d64cc/peta%20sebaran.png" />

West Java contributed the largest share of sales, accounting for 29.5% of total revenue. More broadly, 61.8% of total sales were generated by only 23% of the provinces where the company operates.

Further analysis shows that sales concentration is largely driven by branch distribution. Provinces with more branches tend to generate higher sales, indicating that branch presence is a key driver of revenue performance.

### 4.4 Branch Performance and Underserved Markets

Average sales per branch reached approximately IDR 186 billion, with a variation of only 3.7% across provinces.
This suggests that branches generally perform at a similar level regardless of location, indicating that the company's operating model is scalable and capable of generating consistent revenue across different markets.

When sales are adjusted by population size, several highly populated provinces—including Banten, DKI Jakarta, Central Java, and East Java—generate less than IDR 1 billion in sales per million residents despite populations exceeding 10 million.

This may indicate untapped market potential and relatively low market penetration in some of Indonesia's largest consumer markets. Additionally, the company currently has no branch presence in three provinces, creating further opportunities for expansion.

Additional investigation is recommended to determine whether limited penetration is driven by operational, geographic, regulatory, competitive, or logistical factors.

### 4.5 Inventory Gaps May Lead to Lost Sales Opportunities

Inventory analysis based on average daily unit sales over the most recent three-month period identified stock availability gaps across multiple branches.

A total of 201 product-branch combinations had zero inventory on hand despite generating average daily sales of 3.24 units. Assuming demand remains consistent, these stockouts could result in an estimated gross revenue loss of approximately IDR 2.3 billion over a seven-day period.

This suggests opportunities to improve inventory allocation and replenishment processes, particularly for products with stable demand patterns.

### 4.6 Customer Retention Improved Consistently Between 2021 and 2023

The company served 264,601 unique customers during the analysis period. Annual active customers remained relatively stable at approximately 105,000–106,000 customers per year. Meanwhile, the returning customer rate increased steadily from 37.74% in 2021 to 51.99% in 2022 and 60.57% in 2023.

The upward trend suggests that customer retention strengthened over time, with a growing share of annual transactions generated by existing customers. This may indicate increasing customer loyalty, improved customer experience, stronger product-market fit, or other retention-related factors that warrant further investigation.

### 4.7 Repeat Customers Represent a Valuable Business Segment

<p align="center">
<img width="600" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/2fe5736944bda9f0e0dc00aded9f70050f3d64cc/Customer%20Contributions.png" />

Out of 264,601 customers, 111,099 made more than one transaction, resulting in a repeat purchase rate of 42%. Repeat customers also reported an average transaction rating of 4.0, indicating generally positive purchasing experiences.

In addition, 10% of customers contribute 45% of total revenue, and 65 customers completed at least 100 transactions during the analysis period, with the most active customer recording 316 transactions.

These findings suggest the presence of a highly engaged customer segment that contributes recurring demand. The company may benefit from targeted retention initiatives, personalized engagement strategies, or loyalty programs designed to strengthen relationships with high-frequency customers.

## Recommendations

### 1. Improve Inventory Allocation Across Branches

**Finding**

A total of 201 product-branch combinations had zero inventory on hand despite ongoing customer demand. Based on the average daily sales over the past three months, these stockouts could result in an estimated gross revenue loss of approximately **IDR 2.3 billion within seven days**.

**Recommendation**

Implement a data-driven inventory reallocation and replenishment process by prioritizing high-demand products with low or zero stock. Redistribute inventory from branches with excess stock to branches experiencing stock shortages, and establish minimum stock thresholds for products with consistent sales demand.

**Expected Impact**

* Reduce potential lost sales caused by stockouts.
* Improve inventory availability across branches.
* Increase product availability for customers, leading to higher customer satisfaction and a lower risk of losing customers to competitors.

### 2. Strengthen Customer Retention Through Loyalty Initiatives

**Finding**

The returning customer rate has increased consistently over the past three years. Additionally, the top 10% of customers contribute approximately **45% of total revenue**, indicating that a relatively small customer segment generates a substantial share of sales.

**Recommendation**

Develop a loyalty program targeting high-value and repeat customers by offering personalized rewards, exclusive promotions, or membership benefits. Complement these initiatives with seasonal promotional campaigns during major holidays, year-end periods, or other peak demand periods to encourage repeat purchases.

**Expected Impact**

* Increase repeat purchase frequency and customer retention.
* Improve customer lifetime value (CLV).
* Generate additional revenue from existing customers while reducing reliance on new customer acquisition.

### 3. Expand Market Penetration in Underserved Provinces

**Finding**

Several highly populated provinces continue to record relatively low sales per million residents, suggesting untapped market potential. In addition, the company currently has no branch presence in three provinces.

**Recommendation**

Conduct a market feasibility analysis to identify the causes of low market penetration in densely populated provinces, including branch coverage, competition, accessibility, and local demand. Based on the findings, evaluate opportunities to expand branch networks or strengthen distribution channels, particularly in provinces where the company currently has no physical presence.

**Expected Impact**

* Increase market penetration in high-potential provinces.
* Acquire new customers through expanded branch coverage.
* Improve access to pharmaceutical products across a broader geographic area.
* Support sustainable long-term revenue growth through geographic expansion.

## Dashboard Preview

<p align="center">
<img width="1000" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/4652f0b59b27adb80e8015f7a6efb432beb94e1f/Kimia%20Farma%20Overview.png" />

<p align="center">
<img width="1000" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/4652f0b59b27adb80e8015f7a6efb432beb94e1f/Kimia%20Farma%20Product.png" />

<p align="center">
<img width="1000" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/4652f0b59b27adb80e8015f7a6efb432beb94e1f/Kimia%20Farma%20Customer.png" />

<p align="center">
<img width="1000" src="https://github.com/rifatz-the-analyst/Image-archieve/blob/125ceccd49aba5e337816fbf296a379f65e32c37/Kimia%20Farma%20Inventory.png" />
