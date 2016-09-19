--business_json = FOREACH business_clean_3 GENERATE business_id, name, full_address, state, city, open, categories, type, review_count, 
--stars, longitude, latitude, REGEX_EXTRACT(full_address, '(.*)\\,\\s(.*)',2) as zipcode;

CREATE TABLE business_hive_table 
	(business_id STRING, name STRING, full_address STRING, state STRING, city STRING, open TINYINT, categories STRING, 
	type STRING, review_count INT, stars DOUBLE, longitude DOUBLE)