# 📊 Olist E-Commerce Strategy Analysis

## 📌 Project Overview
**Role:** Junior Business Analyst  
**Tools:** SQL (MySQL), Window Functions, CTEs  
**Dataset:** [Olist Brazilian E-Commerce Dataset (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

This project analyzes the sales, logistics, and customer retention data of Olist, a Brazilian marketplace connecting small businesses to customers. The goal was to solve real-world business problems regarding growth, supply chain efficiency, and customer loyalty.

---

## 🔍 Key Insights & Findings

### 1. Customer Retention is Critical (KPI 5)
* **Finding:** The retention rate is only **3.12%**.
* **Impact:** Olist is heavily reliant on acquiring new customers rather than retaining existing ones.
* **Recommendation:** Implement a loyalty rewards program or post-purchase email flows to encourage second orders.

### 2. Logistics Bottlenecks (KPI 2)
* **Finding:** The state of **Amapá (AP)** has the highest average delivery delay (~72 days) for late orders.
* **Recommendation:** Investigate carrier performance in the AP region or adjust estimated delivery times to manage customer expectations.

### 3. Pareto Analysis (KPI 7)
* **Finding:** A small percentage of product categories drive the majority of revenue (Health & Beauty, Watches, Bed Bath & Table).
* **Recommendation:** Marketing spend should be optimized to focus on these high-performing categories (The "80/20 Rule").

---

## 🛠️ Technical Skills Demonstrated

* **Advanced Aggregations:** `GROUP BY`, `CASE WHEN` for pivot tables.
* **Window Functions:** `DENSE_RANK()` for seller ranking, `LAG()` for time-series analysis, and Running Totals for Pareto analysis.
* **CTEs (Common Table Expressions):** Used to simplify complex logic like Customer Retention cohorts.
* **Data Accuracy:** Handled potential data duplication issues by joining correctly on `order_items` rather than `payments` for product analysis.

---

## 📂 Project Structure
* `Olist-SQL-Analysis.sql`: Contains the raw SQL code for all 7 KPIs, commented and organized.
* `README.md`: This summary report.

---

*This project was created by [Saurabh Kumar Kushwaha] as part of a portfolio series.*
