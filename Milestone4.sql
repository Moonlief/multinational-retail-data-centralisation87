--Milestone 4


--Task 1: 

SELECT 
	country_code
	, COUNT(*) as total_no_stores
FROM 
	dim_store_details
GROUP BY 
	country_code;

--TASK 2

SELECT 
	locality
	, COUNT(*) as total_no_stores
FROM 
	dim_store_details
GROUP BY
	locality
ORDER BY
	total_no_stores DESC, locality

LIMIT 
	7;

--TASK 3



SELECT 
	ROUND(SUM(o.product_quantity * pro.product_price)::numeric,2) as total_sales
	, ddt.month as month
FROM 
	orders_table as o

JOIN 
	dim_products as pro
	ON pro.product_code = o.product_code
	
JOIN 
	dim_date_times as ddt
	ON ddt.date_uuid = o.date_uuid

GROUP BY
	ddt.month

ORDER BY
	total_sales DESC;
	



--TASK 4


SELECT 
	COUNT(o.index) as number_of_sales
	, SUM(o.product_quantity)as product_quantity_count
	, CASE
		WHEN dsd.store_type = 'Web Portal' THEN 'Web'
		ELSE 'Offline'
	 END
		as location

FROM
	orders_table as o

JOIN 
	dim_store_details as dsd 
	ON o.store_code = dsd.store_code

GROUP BY
	location;

---TASK 5

WITH total_sales AS (
    SELECT ROUND(SUM(o.product_quantity * pro.product_price)::numeric,2) AS total
    FROM orders_table AS o
    JOIN dim_products AS pro ON pro.product_code = o.product_code
)

SELECT 
    dsd.store_type AS store_type
	, ROUND(SUM(o.product_quantity * pro.product_price)::numeric,2) AS total_sales
	, ROUND((SUM(o.product_quantity * pro.product_price) / ts.total * 100)::numeric,2) AS percentage_total
FROM 
    orders_table AS o
JOIN 
    dim_products AS pro ON pro.product_code = o.product_code
JOIN 
    dim_store_details AS dsd ON dsd.store_code = o.store_code
CROSS JOIN 
    total_sales AS ts
GROUP BY 
    dsd.store_type, ts.total;

	
--TASK 6


SELECT ROUND(SUM(o.product_quantity * pro.product_price)::numeric,2) AS total_sales
	, ddt.year as year
	, ddt.month as month

FROM orders_table AS o

	JOIN dim_products AS pro 
	ON pro.product_code = o.product_code

	JOIN dim_date_times as ddt
	ON ddt.date_uuid = o.date_uuid

GROUP BY year, month

ORDER BY total_sales DESC;
	


	
--TASK 7
	
SELECT
	SUM(staff_numbers) as total_staff_numbers
	, country_code
FROM dim_store_details

GROUP BY
	country_code
ORDER BY
	total_staff_numbers DESC;


	
--TASK 8


SELECT
	SUM(ROUND(o.product_quantity * pro.product_price::numeric,2)) as total_sales
	, dsd.store_type as store_type
	,dsd.country_code as country_code
	
FROM 
	orders_table as o

JOIN 
	dim_products as pro
	ON pro.product_code = o.product_code

JOIN dim_store_details as dsd
	ON dsd.store_code = o.store_code

WHERE 
	country_code = 'DE'

GROUP BY 
	dsd.store_type, dsd.country_code

ORDER BY
	total_sales;




--TASK 9

'Sales would like the get an accurate metric for how quickly the company is making sales.

Determine the average time taken between each sale grouped by year, the query should 
	return the following information:
Hint: You will need the SQL command LEAD.
 +------+-------------------------------------------------------+
 | year |                           actual_time_taken           |
 +------+-------------------------------------------------------+
 | 2013 | "hours": 2, "minutes": 17, "seconds": 12, "millise... |
 | 1993 | "hours": 2, "minutes": 15, "seconds": 35, "millise... |
 | 2002 | "hours": 2, "minutes": 13, "seconds": 50, "millise... | 
 | 2022 | "hours": 2, "minutes": 13, "seconds": 6,  "millise... |
 | 2008 | "hours": 2, "minutes": 13, "seconds": 2,  "millise... |
 +------+-------------------------------------------------------+'



--- Adding two new columns

ALTER TABLE dim_date_times
	ADD COLUMN IF NOT EXISTS converted_timestamp timestamp
ALTER TABLE dim_date_times
	ADD COLUMN IF NOT EXISTS concat_timestamp varchar(100)

-- concat the time values into one column
UPDATE dim_date_times
	SET concat_timestamp = 
		CONCAT(year,'-',month,'-',day,' ',timestamp)

--- converting the concat_timestamp into timestamp data
UPDATE dim_date_times
	SET converted_timestamp = TO_TIMESTAMP(concat_timestamp, 'YYYY-MM-DD HH24:MI:SS')


---- 
SELECT
	year
	,CONCAT(
			'"hours": '
			, extract(HOUR from AVG_time_difference)
			, ' "minutes": '
			, extract(MINUTE from AVG_time_difference)
			, ' "seconds": '
			, FLOOR( extract(SECOND from AVG_time_difference))
			, ' "milliseconds": '
			, FLOOR( (extract(SECOND from AVG_time_difference) - (FLOOR(extract(SECOND from AVG_time_difference)))) * 100)
			) 
				as time_difference
	
FROM

		(
		SELECT 
		    year
			,AVG(time_difference) as AVG_time_difference
			
		FROM 
		    (
			SELECT
				year
				, converted_timestamp
		        , LEAD(converted_timestamp) OVER (ORDER BY converted_timestamp) AS next_sale
		        , LEAD(converted_timestamp) OVER (ORDER BY converted_timestamp) - converted_timestamp AS time_difference
		     FROM dim_date_times
			ORDER BY converted_timestamp
			) as cs
		
		GROUP BY 
		    year
		)

