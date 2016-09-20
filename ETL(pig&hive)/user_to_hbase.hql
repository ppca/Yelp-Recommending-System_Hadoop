--user_json = FOREACH user_raw_2 GENERATE $0 AS funny_votes, $1 AS useful_votes, $2 AS cool_votes, user_id, 
--name, average_stars, review_count, type, (INT) (funny+cool+useful) AS total_votes;

CREATE EXTERNAL TABLE yelp_user_hive_sync(
    funny_votes INT,
    useful_votes INT,
    cool_votes INT,
    user_id STRING,
    name STRING,
    average_stars DOUBLE,
    review_count INT,
    type STRING,
    total_votes INT)
COMMENT 'intermediate user data table'
ROW FORMAT
DELIMITED FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n';

LOAD DATA INPATH '/user/ppca/output/user_json_table' OVERWRITE INTO TABLE yelp_user_hive_sync;

CREATE EXTERNAL TABLE yelp_user_hive_sync2(
    funny_votes INT,
    useful_votes INT,
    cool_votes INT,
    user_id STRING,
    name STRING,
    average_stars DOUBLE,
    review_count INT,
    type STRING,
    total_votes INT)
COMMENT 'intermediate user data table'
ROW FORMAT
DELIMITED FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ("hbase.columns.mapping" = "user:funny_votes,user:useful_votes,user:cool_votes,:key,user:name,user:average_stars,user:review_count,user:type,user:total_votes")
TBLPROPERTIES ("hbase.table.name" = "yelp_user_hive_sync");

OVERWRITE INTO TABLE yelp_user_hive_sync2 SELECT * FROM yelp_user_hive_sync;
