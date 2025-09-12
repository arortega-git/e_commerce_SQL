# 🛒 E-Commerce Analytics with SQL & BigQuery

## 📖 Project Overview

This project showcases SQL analytics on a **synthetic e-commerce dataset** generated with Python. The main focus is on using **BigQuery** to explore user behavior, product performance, and revenue trends.  

The dataset includes tables for users, products, orders, order items, and user events, allowing a variety of analyses from retention and churn detection to basket analysis and revenue tracking.  

---

## ⚙️ Tech Stack

- 🐍 Python (data generation)  
- 🗄️ BigQuery (SQL analytics)  
- 💾 SQLite (original database for data generation)  
- 📊 SQL (window functions, joins, aggregation, percentiles)  

---

## 🧩 SQL Analysis Questions

### 1️⃣ User Cohorts & Retention
- **Goal**: Track how many users sign up each month and how many place orders in subsequent months.  
- **SQL Concepts**: `DATE_TRUNC`, joins, window functions (`COUNT(DISTINCT user_id) OVER ...`)

### 2️⃣ Repeat Orders & Time Gaps
- **Goal**: Calculate the average number of days between orders per user.  
- **SQL Concepts**: `LAG(order_date)`, `AVG()`, ordering by user and date  

### 3️⃣ Top Products Over Time
- **Goal**: Identify the top 5 most sold products in each quarter.  
- **SQL Concepts**: `ROW_NUMBER() OVER (PARTITION BY quarter ORDER BY SUM(quantity) DESC)`  

### 4️⃣ Revenue per User & Percentiles
- **Goal**: Calculate total spend per user and classify users into percentiles (top 10%, middle 40%, etc.).  
- **SQL Concepts**: `SUM(quantity * price)`, `NTILE()` window function  

### 5️⃣ Conversion by Country
- **Goal**: Find the country with the highest conversion rate (users with at least one order / total users).  
- **SQL Concepts**: subqueries, aggregations per country  

### 6️⃣ Category Revenue Trend
- **Goal**: Track monthly revenue per product category.  
- **SQL Concepts**: `SUM(price * quantity)`, `LAG()` for month-over-month growth  

### 7️⃣ Churn Detection
- **Goal**: Identify users who haven’t placed an order in the last 90 days.  
- **SQL Concepts**: `MAX(order_date)`, date differences (`DATE_DIFF` / `CURRENT_DATE`)  

### 8️⃣ Basket Size & Outliers
- **Goal**: Compute average basket size per order and detect orders 2 standard deviations above the mean.  
- **SQL Concepts**: `COUNT()`, `AVG()`, `STDDEV()`, window functions, filtering by `> avg + 2*stddev`  

---

## 🏗️ Project Structure

```
ecommerce-sql-project/
│
├─ data/                  # Synthetic database and exported CSVs
│   └─ ecommerce.db
|   └─ data_generation.py
├─ exports/                  # Exported CSV's and exporting script
│   └─ export_csv.py
|   └─ order_items.csv
|   └─ orders.csv
|   └─ products.csv
|   └─ users.csv
├─ queries/               # SQL queries for each analysis
│   ├─ user_cohorts.sql
│   ├─ repeat_orders.sql
│   ├─ top_products.sql
│   ├─ revenue_percentiles.sql
│   ├─ conversion_country.sql
│   ├─ category_revenue.sql
│   ├─ churn_detection.sql
│   └─ basket_size_outliers.sql
└─ README.md              # This file
```

---

## 🚀 Usage

1. Clone the repo:  
```bash
git clone https://github.com/your-username/ecommerce-sql-project.git
```

2. Load the database (`ecommerce.db`) or directly use BigQuery with the provided CSVs.  

3. Run SQL queries in BigQuery console or your preferred SQL client to reproduce the analysis.  

---

## 📊 Skills Demonstrated

- Advanced SQL: window functions, joins, aggregation, percentiles  
- E-commerce analytics: retention, conversion, revenue, basket analysis  
- Data modeling with relational databases  
- Python for synthetic data generation  

---

## 📌 Next Steps

- Add more users/products/events to scale the analysis 📈  
- Build dashboards (Power BI / Tableau) to visualize trends 📊  
- Implement automated ETL pipelines for live e-commerce data ⏱️  

---

✍️ **Author**: Arturo Ortega – Learning project for SQL & BigQuery analytics

