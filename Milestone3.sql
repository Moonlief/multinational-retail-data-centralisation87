--TASK 1 orders_table

-- Finding about the maximum length

-- card_number = VARCHAR(19)
--date_uuid = UUID
--user_uuid = uUID
--  store_code = VARCHAR(12)
-- product_code = VARCHAR(11)
--product_quantity

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


ALTER TABLE orders_table
	ALTER COLUMN card_number TYPE VARCHAR(19),
	ALTER COLUMN store_code TYPE VARCHAR(12),
	ALTER COLUMN product_code TYPE VARCHAR(11),
	ALTER COLUMN product_quantity TYPE smallint,
	ALTER COLUMN date_uuid TYPE UUID USING date_uuid::uuid, 
	ALTER COLUMN user_uuid TYPE UUID USING user_uuid::uuid ; 


--- TASK 2 dim_users

+----------------+--------------------+--------------------+
| dim_users      | current data type  | required data type |
+----------------+--------------------+--------------------+
| first_name     | TEXT               | VARCHAR(255)       |
| last_name      | TEXT               | VARCHAR(255)       |
| date_of_birth  | TEXT               | DATE               |
| country_code   | TEXT               | VARCHAR(10)         |
| user_uuid      | TEXT               | UUID               |
| join_date      | TEXT               | DATE               |
+----------------+--------------------+--------------------+

	--~  !~ '^\d{4}-\d{2}-\d{2}$'
	
--
ALTER TABLE dim_users

		ALTER COLUMN join_date TYPE DATE USING JOIN_DATE::date
;

SELECT * from dim_users where join_date LIKE 'null' ;

3CUODA3HTC, 3CUODA3HTC


SELECT * from dim_users where join_date !~ '^\d{4}-\d{2}-\d{2}$'  order by join_date
	
; 		ALTER COLUMN user_uuid TYPE UUID USING user_uuid::uuid;

	


	ALTER COLUMN first_name TYPE VARCHAR(255),
	ALTER COLUMN country_code TYPE VARCHAR(10),
	ALTER COLUMN date_of_birth TYPE DATE USING date_of_birth::date
	ALTER COLUMN last_name TYPE VARCHAR(255);

	;


SELECt user_uuid from dim_users
	order by user_uuid ASC;



