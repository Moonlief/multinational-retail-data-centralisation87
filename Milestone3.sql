--TASK 1 orders_table

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


ALTER TABLE orders_table
	ALTER COLUMN card_number TYPE VARCHAR(19),
	ALTER COLUMN store_code TYPE VARCHAR(17),
	ALTER COLUMN product_code TYPE VARCHAR(11),
	ALTER COLUMN product_quantity TYPE smallint,
	ALTER COLUMN date_uuid TYPE UUID USING date_uuid::uuid, 
	ALTER COLUMN user_uuid TYPE UUID USING user_uuid::uuid ; 


-- TASK 2 dim_users

---- Cleaning data

		DELETE FROM dim_users WHERE user_uuid = 'NULL';
		
		DELETE FROM dim_users where first_name ~ '[0-9]+' ;

---- Altering Table
		ALTER TABLE dim_users
			ALTER COLUMN first_name TYPE VARCHAR(255),
			ALTER COLUMN country_code TYPE VARCHAR(10),
			ALTER COLUMN date_of_birth TYPE DATE USING date_of_birth::date,
			ALTER COLUMN last_name TYPE VARCHAR(255),
			ALTER COLUMN join_date TYPE DATE USING JOIN_DATE::date
			ALTER COLUMN user_uuid TYPE UUID USING user_uuid :: UUID
		;



-- TASK 3 dim_store_details

--- Clean data 
----- Deleting rows where the longitude has letters			
		DELETE FROM dim_store_details WHERE longitude ~ '[A-Za-z]' 
			
----- reformatting dates			
	
			UPDATE dim_store_details SET opening_date = REPLACE (opening_date, '1994 November 24','1994-11-24');
			UPDATE dim_store_details SET opening_date = REPLACE (opening_date, '2001 May 04','2001-05-04');
			UPDATE dim_store_details SET opening_date = REPLACE (opening_date, '2016 November 25','2016-11-25');
			UPDATE dim_store_details SET opening_date = REPLACE (opening_date, '2020 February 01','2020-02-01');
			UPDATE dim_store_details SET opening_date = REPLACE (opening_date, 'October 2012 08','2012-02-08');
			UPDATE dim_store_details SET opening_date = REPLACE (opening_date, 'July 2015 14','2015-07-14');
			UPDATE dim_store_details SET opening_date = REPLACE (opening_date, 'October 2006 04','2006-10-04');
			UPDATE dim_store_details SET opening_date = REPLACE (opening_date, 'May 2003 27','2003-05-27');
			UPDATE dim_store_details SET opening_date = REPLACE (opening_date, 'February 2009 28','2009-02-28');
			UPDATE dim_store_details SET opening_date = REPLACE (opening_date, 'March 2015 02','2015-03-02');

----- remove strings from staff numbers column			

		UPDATE dim_store_details SET staff_numbers = REGEXP_REPLACE(staff_numbers, '[^0-9]', '', 'g');




---- alternating table

		ALTER TABLE dim_store_details
				ALTER COLUMN longitude TYPE float USING longitude::double precision,
				ALTER COLUMN locality  TYPE VARCHAR(255),
				ALTER COLUMN store_code TYPE VARCHAR(11),
				ALTER COLUMN opening_date TYPE date USING opening_date ::date,
				ALTER COLUMN store_type TYPE VARCHAR(255),
				ALTER COLUMN store_type DROP NOT NULL,	
				ALTER COLUMN latitude TYPE float USING latitude::double precision,
				ALTER COLUMN country_code TYPE varchar(2),
				ALTER COLUMN continent TYPE VARCHAR(255),
				ALTER COLUMN staff_numbers TYPE SMALLINT USING staff_numbers::smallint;
			

	
-- TASK 4 dim_products

---- Remove £ character
		UPDATE dim_products SET product_price = REPLACE (product_price, '£','');

---- weight class
		ALTER TABLE dim_products ADD COLUMN easy_weight VARCHAR(55);
		
		UPDATE dim_products SET easy_weight = CASE
		    WHEN weight_kg < 2 THEN 'Light'
		    WHEN weight_kg >= 2 AND weight_kg < 40 THEN 'Mid_Sized'
		    WHEN weight_kg >= 40 AND weight_kg < 140 THEN 'Heavy'
		    WHEN weight_kg >= 140 THEN 'Truck_Required'
		END;



-- TASK 5 dim_products

---- change table names
		ALTER TABLE  dim_products 
			RENAME COLUMN removed TO still_available;
		
		ALTER TABLE  dim_products 
		
			RENAME COLUMN easy_weight TO weight_class;

--- Change values into Boolean values: True or False for still_available
		UPDATE dim_products SET still_available = CASE
		    WHEN still_available = 'Still_avaliable' THEN 'TRUE'
		    WHEN still_available = 'REMOVED' THEN 'FALSE'
		
		END;
	
--- Update the column values
		ALTER TABLE dim_products
			ALTER COLUMN product_price TYPE FLOAT USING product_price::double precision,
			ALTER COLUMN weight_kg TYPE FLOAT,
			ALTER COLUMN "EAN" TYPE VARCHAR(19),
			ALTER COLUMN product_code TYPE VARCHAR(11),
			ALTER COLUMN date_added TYPE DATE USING dim_products.date_added:: DATE,
			ALTER COLUMN uuid TYPE UUID USING uuid :: UUID,
			ALTER COLUMN still_available TYPE BOOL USING still_available::boolean,
			ALTER COLUMN weight_class TYPE VARCHAR(14);
		


-- TASK 6 dim_date_times


---- Deleting Values where time_period has a digit or date_uuid is 'NULL'
		DELETE FROM dim_date_times where time_period ~ '[0-9]+';
		DELETE FROM dim_date_times WHERE date_uuid = 'NULL';

	
--- Altering the Table

		ALTER TABLE dim_date_times
			ALTER COLUMN month TYPE varchar(10),
			ALTER COLUMN year TYPE varchar(10),
			ALTER COLUMN day TYPE varchar(10) ,
			ALTER COLUMN time_period TYPE varchar(10),
			ALTER COLUMN date_uuid TYPE UUID Using dim_date_times.date_uuid :: UUID;
		

-- TASK 7 dim_card_details

--- Deleting rows where card_number is either 'NUll' or contains letters.

		DELETE FROM dim_card_details WHERE card_number = 'NULL';
		DELETE FROM dim_card_details WHERE card_number ~ '[A-Za-z]';


--- Alterting the table
		ALTER TABLE dim_card_details
			ALTER COLUMN card_number  TYPE VARCHAR(22),
			ALTER COLUMN expiry_date TYPE VARCHAR(10),
			ALTER COLUMN date_payment_confirmed TYPE DATE USING date_payment_confirmed:: DATE;
		



-- TASK 8:Primary Keys

--- Adding Primary Keys
		
		ALTER TABLE dim_card_details
			ADD PRIMARY KEY (card_number);
		
		ALTER TABLE dim_date_times
			ADD PRIMARY KEY (date_uuid);
		
		ALTER TABLE dim_products
			ADD PRIMARY KEY (product_code);
		
		ALTER TABLE dim_store_details
			ADD PRIMARY KEY (store_code);
		
		ALTER TABLE dim_users
			ADD PRIMARY KEY (user_uuid);



--TASK 9 - Foreign Keys


		ALTER TABLE orders_table 
		ADD CONSTRAINT date_uuid_fk 
		FOREIGN KEY (date_uuid) 
		REFERENCES dim_date_times (date_uuid);
		
		ALTER TABLE orders_table 
		ADD CONSTRAINT user_uuid_fk 
		FOREIGN KEY (user_uuid) 
		REFERENCES dim_users (user_uuid);

		-- Inserting unique values (foreign key) from the child table (orders_table)
		--into the parent table dim_store_details
		-- dstore_code  as primary key
		
		--- changing the varchar limit in the parent table
		
			ALTER TABLE dim_store_details
				ALTER COLUMN store_code TYPE VARCHAR(17);
			
		--- inserting the missing vlaue from the child table into the parent table
			INSERT INTO dim_store_details (store_code)
			SELECT DISTINCT orders_table.store_code
			FROM orders_table
			LEFT JOIN dim_store_details ON orders_table.store_code = dim_store_details.store_code
			WHERE dim_store_details.store_code IS NULL;
		
		
		---- Adding foreign key
			ALTER TABLE orders_table 
			ADD CONSTRAINT store_code_fk 
			FOREIGN KEY (store_code) 
			REFERENCES dim_store_details (store_code);


---

		ALTER TABLE orders_table 
		ADD CONSTRAINT product_code_fk 
		FOREIGN KEY (product_code) 
		REFERENCES dim_products (product_code);



		-- Inserting unique values (foreign key) from the child table (orders_table)
		--into the parent table
		-- dim_card_details as primary key
		
				INSERT INTO dim_card_details (card_number)
				SELECT DISTINCT orders_table.card_number
				FROM orders_table
				LEFT JOIN dim_card_details ON orders_table.card_number = dim_card_details.card_number
				WHERE dim_card_details.card_number IS NULL;
		
		
				ALTER TABLE orders_table 
				ADD CONSTRAINT card_number_fk 
				FOREIGN KEY (card_number) 
				REFERENCES dim_card_details (card_number);




