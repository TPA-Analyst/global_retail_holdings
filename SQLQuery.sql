-- Q1
select count(distinct s.order_number) as Total_orders_2020
from retails.sales as s
where s.order_date >= '2020-01-01'
	and s.order_date < '2021-01-01'

-- Q2
select p.category,
	count(*) as sku_count
from retails.products as p
group by p.category
order by p.category

-- Q3
select top 10 
	c.city,
	c.state,
	c.country,
	count(customer_key) as Total_customers
from retails.customers as c
group by c.city, c.state, c.country
order by Total_customers desc, c.city

-- Q4
select sum(s.quantity * p.unit_price_usd) as Revenue_USD
from retails.sales as s
join retails.products as p
	on s.product_key = p.product_key
where s.order_date >= '2020-12-01'
	and s.order_date < '2021-01-01'

-- Q5
select s.country,
	count(*) as Stores_by_country
from retails.stores as s
group by s.country
order by Stores_by_country desc;

-- Q6
with product_sales as (
	select
		p.category,
		p.product_name,
		sum(s.quantity) as Total_quantity
	from retails.products as p
	join retails.sales as s
		on p.product_key = s.product_key
	group by p.category, p.product_name
),
ranked as (
	select
		category,
		product_name,
		Total_quantity,
		ROW_NUMBER() over (
			partition by category
			order by Total_quantity desc, product_name
		) as rank_in_category
	from product_sales
)
select category, product_name, Total_quantity, rank_in_category
from ranked
where rank_in_category <= 5
order by category, rank_in_category;

-- Q7
select p.subcategory,
	count(*) as Product_count,
	cast(avg((p.unit_price_usd - p.unit_cost_usd) / nullif(p.unit_price_usd, 0))*100 as decimal(10,2)) as AVG_margin_gross
from retails.products as p
group by p.subcategory
having count(*) >= 10
order by AVG_margin_gross desc;

-- Q8
with delivered as (
	select distinct
		s.order_number,
		s.customer_key,
		s.order_date,
		s.delivery_date
	from retails.sales as s
	where s.delivery_date is not null
)
select
	 c.country,
	 count(*) as Delivery_orders,
	 cast(
		avg(cast(DATEDIFF(day, d.order_date, d.delivery_date) as decimal(10,2)))
		as decimal(10,2)
	) as AVG_delivery_date
from delivered as d
join retails.customers as c
	on c.customer_key = d.customer_key
group by c.country
order by AVG_delivery_date desc;

-- Q9
with customer_spend as (
	select c.name,
		c.country,
		c.customer_key,
		sum(s.quantity * p.unit_price_usd) as total_spend_usd
	from retails.sales as s
	join retails.customers as c
		on s.customer_key = c.customer_key
	join retails.products as p
		on s.product_key = p.product_key
	where s.order_date >= '2020-01-01'
		and s.order_date < '2021-01-01'
	group by c.name, c.country, c.customer_key
),
ranked as (
	select country,
		name,
		total_spend_usd,
		row_number() over(
			partition by country
			order by total_spend_usd desc, name
		) as rn
	from customer_spend
)
select country, name,
	cast(total_spend_usd as decimal(14,2)) as total_spend_usd
from ranked
where rn =1
order by total_spend_usd desc;

-- Q10
select p.product_key,
	p.product_name,
	p.brand,
	p.category
from retails.products as p
left join retails.sales as s
	on p.product_key = s.product_key
where s.product_key is null
order by p.product_name, p.category
--where not exists (
--	select 1
--	from retails.sales as s
--	where p.product_key = s.product_key)
--order by p.category, p.product_name

-- Q11
WITH bounds AS (
  SELECT DATEFROMPARTS(YEAR(MAX(order_date)), MONTH(MAX(order_date)), 1) AS last_month
  FROM retails.sales
),
monthly AS (
  SELECT
    DATEFROMPARTS(YEAR(s.order_date), MONTH(s.order_date), 1) AS month_start,
    SUM(s.quantity * p.unit_price_usd) AS revenue_usd
  FROM retails.sales AS s
  JOIN retails.products AS p
    ON p.product_key = s.product_key
  CROSS JOIN bounds AS b
  WHERE s.order_date >= DATEADD(MONTH, -23, b.last_month)
  GROUP BY DATEFROMPARTS(YEAR(s.order_date), MONTH(s.order_date), 1)
)
SELECT
  FORMAT(month_start, 'yyyy-MM') AS year_month,
  CAST(revenue_usd AS DECIMAL(14, 2)) AS revenue_usd,
  CAST(
    SUM(revenue_usd) OVER (ORDER BY month_start ROWS UNBOUNDED PRECEDING)
    AS DECIMAL(14, 2)
  ) AS cumulative_revenue_usd
FROM monthly
ORDER BY month_start;

-- Q12
WITH cohort AS (
  SELECT
    s.customer_key,
    YEAR(MIN(s.order_date)) AS cohort_year
  FROM retails.sales AS s
  GROUP BY s.customer_key
),
cohort_size AS (
  SELECT cohort_year, COUNT(*) AS cohort_customers
  FROM cohort
  GROUP BY cohort_year
),
activity AS (
  SELECT DISTINCT
    c.cohort_year,
    s.customer_key,
    YEAR(s.order_date) - c.cohort_year AS year_offset
  FROM retails.sales AS s
  JOIN cohort AS c
    ON c.customer_key = s.customer_key
)
SELECT
  cs.cohort_year,
  cs.cohort_customers,
  a.year_offset,
  COUNT(DISTINCT a.customer_key) AS active_customers,
  CAST(100.0 * COUNT(DISTINCT a.customer_key) / cs.cohort_customers AS DECIMAL(5, 2)) AS retention_pct
FROM activity AS a
JOIN cohort_size AS cs
  ON cs.cohort_year = a.cohort_year
WHERE a.year_offset BETWEEN 0 AND 3
GROUP BY cs.cohort_year, cs.cohort_customers, a.year_offset
ORDER BY cs.cohort_year, a.year_offset;

-- Q13
WITH store_revenue AS (
  SELECT
    st.store_key,
    st.country,
    st.square_meters,
    SUM(s.quantity * p.unit_price_usd) AS revenue_usd
  FROM retails.sales AS s
  JOIN retails.products AS p
    ON p.product_key = s.product_key
  JOIN retails.stores AS st
    ON st.store_key = s.store_key
  WHERE s.order_date >= '2020-01-01'
    AND s.order_date < '2021-01-01'
    AND st.square_meters > 0
  GROUP BY st.store_key, st.country, st.square_meters
)
SELECT
  store_key,
  country,
  CAST(revenue_usd / square_meters AS DECIMAL(12, 2)) AS revenue_per_sqm,
  NTILE(4) OVER (
    PARTITION BY country
    ORDER BY revenue_usd / square_meters DESC
  ) AS quartile_in_country
FROM store_revenue
ORDER BY country, quartile_in_country, revenue_per_sqm DESC;

-- Q14
WITH store_pairs AS (
  SELECT
    incumbent.store_key AS incumbent_store,
    newcomer.store_key AS new_store,
    incumbent.country,
    newcomer.open_date AS new_store_open_date
  FROM retails.stores AS incumbent
  JOIN retails.stores AS newcomer
    ON newcomer.country = incumbent.country
   AND newcomer.open_date > incumbent.open_date
),
windowed AS (
  SELECT
    sp.incumbent_store,
    sp.new_store,
    sp.country,
    sp.new_store_open_date,
    SUM(CASE
      WHEN s.order_date >= DATEADD(MONTH, -6, sp.new_store_open_date)
       AND s.order_date < sp.new_store_open_date
      THEN s.quantity * p.unit_price_usd
    END) AS revenue_before,
    SUM(CASE
      WHEN s.order_date >= sp.new_store_open_date
       AND s.order_date < DATEADD(MONTH, 6, sp.new_store_open_date)
      THEN s.quantity * p.unit_price_usd
    END) AS revenue_after
  FROM store_pairs AS sp
  JOIN retails.sales AS s
    ON s.store_key = sp.incumbent_store
  JOIN retails.products AS p
    ON p.product_key = s.product_key
  GROUP BY sp.incumbent_store, sp.new_store, sp.country, sp.new_store_open_date
)
SELECT
  incumbent_store,
  new_store,
  country,
  new_store_open_date,
  CAST(revenue_before AS DECIMAL(14, 2)) AS revenue_before,
  CAST(ISNULL(revenue_after, 0) AS DECIMAL(14, 2)) AS revenue_after,
  CAST(100.0 * (ISNULL(revenue_after, 0) - revenue_before) / revenue_before AS DECIMAL(7, 2)) AS change_pct
FROM windowed
WHERE revenue_before > 0
  AND ISNULL(revenue_after, 0) < revenue_before * 0.85
ORDER BY change_pct, incumbent_store, new_store;

-- Q15
WITH order_products AS (
  SELECT DISTINCT s.order_number, s.product_key
  FROM retails.sales AS s
),
total_orders AS (
  SELECT COUNT(DISTINCT order_number) AS order_count
  FROM retails.sales
),
pairs AS (
  SELECT
    a.product_key AS product_a_key,
    b.product_key AS product_b_key,
    COUNT(*) AS times_together
  FROM order_products AS a
  JOIN order_products AS b
    ON b.order_number = a.order_number
   AND b.product_key > a.product_key
  GROUP BY a.product_key, b.product_key
)
SELECT TOP (20)
  pa.product_name AS product_a,
  pb.product_name AS product_b,
  pr.times_together,
  CAST(100.0 * pr.times_together / t.order_count AS DECIMAL(8, 4)) AS pct_of_orders
FROM pairs AS pr
JOIN retails.products AS pa
  ON pa.product_key = pr.product_a_key
JOIN retails.products AS pb
  ON pb.product_key = pr.product_b_key
CROSS JOIN total_orders AS t
ORDER BY pr.times_together DESC, product_a, product_b;