-- Create Tabel Analisis
CREATE TABLE kimia_farma.kf_tabel_analisis AS
WITH gross_laba AS
    (SELECT
			f.transaction_id,
			f.date as dates,
			c.branch_id,
			c.branch_name,
			c.kota,
			c.provinsi,
			c.rating rating_cabang,
			f.customer_name,
			p.product_id,
			p.product_name,
			p.price,
			f.discount_percentage,
			CASE WHEN p.price > 500000 THEN 0.30
					WHEN p.price > 300000 THEN 0.25
					WHEN p.price > 100000 THEN 0.20
					WHEN p.price > 50000 THEN 0.15
					WHEN p.price <= 50000 THEN 0.10
			END persentase_gross_laba,
			round(p.price * (1 - f.discount_percentage)) net_sales,
			f.rating rating_transaksi
    FROM `kimia_farma.kf_final_transaction` f
    LEFT JOIN `kimia_farma.kf_kantor_cabang` c ON f.branch_id = c.branch_id
    LEFT JOIN `kimia_farma.kf_product` p ON p.product_id = f.product_id)
SELECT
	transaction_id,
	dates,
	branch_id,
	branch_name,
	kota,
	provinsi,
	rating_cabang,
	customer_name,
	product_id,
	product_name,
	price,
	discount_percentage,
	persentase_gross_laba,
	net_sales,
	(price * persentase_gross_laba)-(price - net_sales) net_profit,
	rating_transaksi
FROM gross_laba;

-- Create Tabel Analisis Inventory
CREATE TABLE kimia_farma.kf_analisis_inventory AS
WITH unit_sales AS
	(SELECT
		product_id,
		dates,
		COUNT(*) unit_sales
	FROM `kimia_farma.kf_tabel_analisis`
	WHERE dates BETWEEN '2023-10-01' AND '2023-12-31'
	GROUP BY product_id, dates),
daily_sales AS
	(SELECT
		product_id,
		round(AVG(unit_sales.unit_sales), 2) daily_sold
	FROM unit_sales
    GROUP BY product_id),
stock AS
	(SELECT
		branch_id,
		product_id,
		SUM(opname_stock) opname_stock
	FROM `kimia_farma.kf_inventory`
	GROUP BY branch_id, product_id)
SELECT
	s.branch_id,
	s.product_id,
	d.daily_sold,
	s.opname_stock,
	round(s.opname_stock/d.daily_sold, 2) coverage_days
FROM daily_sales d
JOIN stock s ON s.product_id = d.product_id
ORDER BY round(s.opname_stock/d.daily_sold, 2);

-- Market Penetration
WITH province_sales AS
	(SELECT
		d.provinsi,
		d.jumlah_penduduk_2023,
		SUM(t.net_sales) net_sales
	FROM `kimia_farma.kf_demografi` d
	LEFT JOIN `kimia_farma.kf_tabel_analisis` t
	ON d.provinsi = t.provinsi
	GROUP BY d.provinsi, d.jumlah_penduduk_2023)
SELECT
	*,
	net_sales/jumlah_penduduk_2023*1000000 market_penetration
FROM province_sales
WHERE net_sales/jumlah_penduduk_2023*1000000 IS NOT NULL
ORDER BY net_sales/jumlah_penduduk_2023*1000000 DESC;

-- Total Orders and Total Sales by Customers
SELECT
	customer_name,
	COUNT(transaction_id) total_transaksi,
	SUM(net_sales) total_net_sales,
    SUM(net_profit) net_profit,
	round(AVG(rating_transaksi),1) rating_transaksi
FROM `kimia_farma.kf_tabel_analisis`
GROUP BY customer_name
ORDER BY COUNT(transaction_id) DESC;

-- Total Customers, New Customers, and Returning Customers
WITH first_time AS
	(SELECT
		customer_name,
		MIN(dates) first_order
	FROM `kimia_farma.kf_tabel_analisis`
	GROUP BY customer_name),
new_customer AS
	(SELECT
		extract(YEAR FROM first_order) first_order_year,
		COUNT(*) new_customer
	FROM first_time
	GROUP BY extract(YEAR FROM first_order)
	ORDER BY extract(YEAR FROM first_order) ASC),
total AS
	(SELECT
		extract(YEAR FROM dates) years,
		COUNT(DISTINCT customer_name) total_customer
	FROM `kimia_farma.kf_tabel_analisis`
	GROUP BY extract(YEAR FROM dates))
SELECT
	years,
	new_customer,
	total_customer-new_customer returning_customer,
	total_customer,
	round((total_customer-new_customer)/total_customer*100,2) returning_rate
FROM total t
JOIN new_customer n
ON t.years = n.first_order_year;

-- Repeat Orders
WiTH customer_value AS
  (SELECT
      customer_name,
      COUNT(transaction_id) total_transaksi,
      SUM(net_sales) net_sales,
      SUM(net_profit) net_profit,
      round(AVG(rating_transaksi),1) rating_transaksi
  FROM `kimia_farma.kf_tabel_analisis`
  GROUP BY customer_name
  ORDER BY COUNT(transaction_id) DESC),
repeat_order AS
  (SELECT
    customer_name,
    total_transaksi,
    net_sales,
    net_profit,
    rating_transaksi,
  CASE WHEN total_transaksi > 1 THEN 'repeat'
    ELSE 'new'
  END type
  FROM customer_value)
SELECT
  type,
  COUNT(*)
FROM repeat_order
GROUP BY type;

-- Customer Contribution
WITH customer_value AS
(SELECT
	customer_name,
	COUNT(transaction_id) total_transaksi,
	SUM(net_sales) total_net_sales,
    SUM(net_profit) total_net_profit,
	round(AVG(rating_transaksi),1) rating_transaksi
FROM `kimia_farma.kf_tabel_analisis`
GROUP BY customer_name
ORDER BY SUM(net_sales)),
numbers AS
  (SELECT
    customer_name,
    total_transaksi,
    total_net_sales,
    ROW_NUMBER() OVER() num
  FROM customer_value)
SELECT
  *,
  CASE WHEN num >= 238141 THEN 'top 10'
      WHEN num >= 185221 THEN 'next 20'
      WHEN num >= 105841 THEN 'next 30'
  ELSE 'bottom 40'
  END contribution
FROM numbers;

-- Potential Revenue Loss over 7 Days Period
WITH product_price AS
	(SELECT
		c.branch_id,
		c.product_id,
		p.price,
		c.daily_sold,
		c.opname_stock,
		c.coverage_days
	FROM `kimia_farma.kf_analisis_inventory` c
	LEFT JOIN `kimia_farma.kf_product` p
	ON c.product_id = p.product_id
	WHERE opname_stock = 0),
potential_loss AS
(SELECT
	product_id,
	round(AVG(daily_sold),2) daily_sold,
	SUM(price) potential_lost
FROM product_price
GROUP BY product_id)
SELECT
SUM((daily_sold*potential_lost)*7) total_loss
FROM potential_loss;

-- Branch with Zero Stock
WITH product_price AS
	(SELECT
		c.branch_id,
		c.product_id,
		p.price,
		c.daily_sold,
		c.opname_stock,
		c.coverage_days
	FROM `kimia_farma.kf_analisis_inventory` c
	LEFT JOIN `kimia_farma.kf_product` p
	ON c.product_id = p.product_id
	WHERE opname_stock = 0),
zero_stock AS
  (SELECT
      branch_id,
      product_id,
      SUM(opname_stock) total_stock
  FROM product_price
  GROUP BY branch_id, product_id
  HAVING SUM(opname_stock) = 0)
SELECT
  branch_id,
  COUNT(*) zero_stock_product
FROM zero_stock
GROUP BY branch_id;

-- Average Product Daily Sold (Unit)
WITH product_price AS
	(SELECT
		c.branch_id,
		c.product_id,
		p.price,
		c.daily_sold,
		c.opname_stock,
		c.coverage_days
	FROM `kimia_farma.kf_analisis_inventory` c
	LEFT JOIN `kimia_farma.kf_product` p
	ON c.product_id = p.product_id
	WHERE opname_stock = 0),
zero_stock AS
  (SELECT
      product_id,
    AVG(daily_sold) avg_daily_sold,
      SUM(opname_stock) total_stock
  FROM product_price
  GROUP BY branch_id, product_id
  HAVING SUM(opname_stock) = 0)
SELECT
  product_id,
	avg_daily_sold,
  COUNT(*) zero_stock_product
FROM zero_stock
GROUP BY product_id,avg_daily_sold;

-- Total Repeat Orders
WiTH customer_value AS
  (SELECT
      customer_name,
      COUNT(transaction_id) total_transaksi,
      SUM(net_sales) net_sales,
      SUM(net_profit) net_profit,
      round(AVG(rating_transaksi),1) rating_transaksi
  FROM `kimia_farma.kf_tabel_analisis`
  GROUP BY customer_name
  ORDER BY COUNT(transaction_id) DESC),
repeat_order AS
  (SELECT
    customer_name,
    total_transaksi,
    net_sales,
    net_profit,
    rating_transaksi,
  CASE WHEN total_transaksi > 1 THEN 'repeat'
    ELSE 'new'
  END type
  FROM customer_value)
SELECT
SUM(CASE WHEN type = 'repeat'
THEN 1
ELSE 0 END) total_repeat,
COUNT(*) total_customer
FROM repeat_order;