--business_json = FOREACH business_clean_3 GENERATE business_id, name, full_address, state, city, open, categories, type, review_count, 
--stars, longitude, latitude, REGEX_EXTRACT(full_address, '(.*)\\,\\s(.*)',2) as zipcode;

CREATE TABLE business_hive_table 
	(business_id STRING, name STRING, full_address STRING, state STRING, city STRING, open TINYINT, categories STRING, 
	type STRING, review_count INT, stars DOUBLE, longitude DOUBLE)

COMMENT 'intermediate non orc table, DATA ABOUT businesss on yelp'
ROW FORMAT
DELIMITED FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n';

LOAD DATA INPATH 'hdfs:///user/ppca/output/json_business_table' OVERWRITE INTO TABLE yelp_business_not_orc;

CREATE TABLE yelp_business_hbase_sync(
    business_id String,
    name String,
    categories String,
    review_count int, 
    stars String, 
    open String,
    full_address String,
    city String,
    state String,
    longitude String,
    latitude String
    )
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
with SERDEPROPERTIES ("hbase.columns.mapping" = ":key, business:name, business:categories, business:review_count, 
    business:stars, business:open, business:full_address, business:city, business:state, business:longitude, business:latitude")
TBLPROPERTIES ("hbase.table.name" = "yelp_business_hive_sync");

INSERT OVERWRITE TABLE yelp_business_hbase_sync SELECT * FROM yelp_business_not_orc;

