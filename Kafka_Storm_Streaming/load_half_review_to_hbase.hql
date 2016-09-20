CREATE EXTERNAL TABLE yelp_review_before2010_not_orc(
    review_id String,
    business_id String,
    user_id String,
    review_stars int, 
    review_date String, 
    review_text String,
    type String,
    votes_funny int,
    votes_useful int,
    votes_cool int
    )
COMMENT 'intermediate non orc table, DATA ABOUT reviews before 2010 on yelp'
ROW FORMAT
DELIMITED FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n';

LOAD DATA INPATH 'hdfs:///user/ppca/output/review_before_2010' OVERWRITE INTO TABLE yelp_review_before2010_not_orc;

CREATE TABLE yelp_review_changing(
    review_id String,
    business_id String,
    user_id String,
    review_stars int, 
    review_date String, 
    review_text String,
    type String,
    votes_funny int,
    votes_useful int,
    votes_cool int
    )
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
with SERDEPROPERTIES ("hbase.columns.mapping" = ":key, review:business_id, review:user_id,review:review_stars, review:review_date, review:review_text, review:type,review:votes_funny, review:votes_useful, review:votes_cool")
TBLPROPERTIES ("hbase.table.name" = "yelp_review_changing");

INSERT OVERWRITE TABLE yelp_review_changing SELECT * FROM yelp_review_before2010_not_orc;

