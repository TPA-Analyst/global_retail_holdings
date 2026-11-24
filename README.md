# 🛒 Xóm Retail – Advanced SQL Analytics Project

> **15 real-world ad-hoc business questions answered with pure T-SQL**  
> From total orders and revenue to customer retention, store cannibalization, and product affinity — all solved with clean, production-ready SQL Server queries.

---

## 📌 Project Overview

This project simulates the daily work of a **Data Analyst** at a multinational retail company.  

**Xóm Retail** is a global chain specializing in premium consumer electronics, home appliances, toys, and accessories. The company operates hundreds of physical stores across North America, Europe, Asia, and Australia, serves over 1.5 million active customers, and manages a catalog of more than 2,500 SKUs.

Leadership teams (Merchandising, Store Operations, CRM, Finance, and the COO) constantly send urgent ad-hoc requests. This repository contains the complete set of **15 SQL solutions** written to answer those requests accurately and efficiently.

---

## 🎯 Business Questions Solved

| #  | Stakeholder              | Question                                      | Key Insight |
|----|--------------------------|-----------------------------------------------|-------------|
| 1  | Data Team Leader         | Total orders in 2020                          | **4,635** orders |
| 2  | Head of Merchandising    | Product categories + SKU count                | 8 categories, Home Appliances has the most SKUs (661) |
| 3  | Head of CRM              | Top 10 cities by customer count               | Toronto leads with **203** customers |
| 4  | Head of Finance          | December 2020 revenue                         | **$651,526** |
| 5  | VP Store Operations      | Number of stores by country                   | United States has the most stores (**24**) |
| 6  | Head of Merchandising    | Top 5 best-selling products per category      | Voice recorders & desktop PCs dominate volume |
| 7  | CFO                      | Average gross margin by subcategory           | Digital SLR Cameras: **60.44%** (highest) |
| 8  | COO                      | Average delivery time by country              | Italy slowest at **4.68 days** |
| 9  | Head of CRM              | VIP customer (highest spender) per country    | Mie Huus (US) spent **$33,275** in 2020 |
| 10 | Head of Merchandising    | "Zombie" products (never sold)                | Several lamps & home appliances never sold a single unit |
| 11 | Head of Finance          | Monthly + 24-month cumulative revenue         | Clear seasonality and growth trend visualized |
| 12 | VP Customer Experience   | Cohort retention (Year 0 → Year 3)            | 2016 cohort retention dropped to 20.7% in Year 1 |
| 13 | VP Store Operations      | Revenue per m² + quartile ranking             | Identified top & bottom quartile stores by country |
| 14 | VP Store Operations      | Store cannibalization analysis                | Multiple cases with revenue drop >15% (up to **–66%**) |
| 15 | CMO                      | Products frequently bought together           | Top co-purchase pairs for recommendation engine |

---

## 🛠️ Technical Stack & Skills Demonstrated

- **Database**: Microsoft SQL Server (T-SQL)
- **Techniques used**:
  - Common Table Expressions (CTEs)
  - Window Functions (`ROW_NUMBER`, `NTILE`, `SUM() OVER`, ranking)
  - Complex multi-table JOINs
  - Date calculations (`DATEFROMPARTS`, `DATEDIFF`, `DATEADD`)
  - Conditional aggregation & percentage calculations
  - Handling NULL values and statistical significance filters (`HAVING`)
  - Self-joins for pair analysis and cannibalization detection

---

## 📂 Repository Structure

```text
├── queries/
│   ├── 01_total_orders_2020.sql
│   ├── 02_product_categories.sql
│   ├── 03_top_cities_by_customers.sql
│   ├── ...
│   └── 15_product_pairs.sql
├── results/                  # Screenshots / result tables
├── Business_Problem_Statement.docx
└── README.md
```

---

## 💡 Key Business Insights

- **Revenue & Sales**: Strong performance in December, with clear monthly seasonality visible in the 24-month cumulative view.
- **Customer Behavior**: Significant retention drop after the first year — a clear opportunity for CRM campaigns.
- **Operations**: Delivery times vary by country (Italy & Canada are slowest). Several stores suffered noticeable revenue cannibalization after new store openings.
- **Merchandising**: High-margin categories (Cameras) vs high-volume categories (Computers & Games). Several "zombie" products identified for clearance.
- **Marketing**: Strong product affinity pairs ready to feed into a recommendation engine.

---

## 🚀 How to Use

1. Open SQL Server Management Studio (or Azure Data Studio).
2. Connect to a database containing the `retails` schema (tables: `sales`, `products`, `customers`, `stores`).
3. Run any query in the `/queries` folder.
4. Results match the business questions listed above.

---

## 📈 What This Project Shows

This is not a simple “SELECT * FROM table” exercise.  
It demonstrates the ability to:

- Translate vague business questions into precise analytical requirements
- Write clean, readable, and efficient T-SQL
- Use advanced SQL features to solve real operational problems
- Deliver actionable insights that stakeholders can immediately use in presentations and decision-making

---

**Built with ☕ and a lot of CTEs**  
*Data Analyst | SQL Server | Retail Analytics*
```
