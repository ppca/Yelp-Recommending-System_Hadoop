business_line = LOAD 'user/ppca/yelp_training_set/yelp_training_set_business.json' AS (line:CHARARRAY);

--no neighborhoods at all
business_clean = FOREACH business_line GENERATE REPLACE(line,'\\"neighborhoods\\"\\:\\s\\[\\]\\,\\s','') AS line; 
--change categories delimitor
business_clean_2 = FOREACH business_clean GENERATE REPLACE($0,'(?<=\\"categories\\"\\:\\s)(\\[.*\\])(?=\\,)',REPLACE(REGEX_EXTRACT($0,'\\"categories\\"\\:\\s\\[(.*)\\]',1),'\\"\\,\\s\\"','|')) AS line;

--split into fields
business_clean_3 = FOREACH business_clean_2 GENERATE 
	REGEX_EXTRACT(line,'\\"business_id\\"\\:\\s\\"(.*?)\\"\\,',1) AS business_id,
	REPLACE(REGEX_EXTRACT(line,'\\"full_address\\"\\:\\s\\"(.*?)\\"\\,',1),'\\\\n','||') AS full_address,
	REGEX_EXTRACT(line,'\\"open\\"\\:\\s(.*?)\\,',1) AS (open:INT),
	REGEX_EXTRACT(line,'\\"categories\\"\\:\\s\\"(.*?)\\"\\,',1) AS categories,
	REGEX_EXTRACT(line,'\\"city\\"\\:\\s\\"(.*?)\\"\\,',1) AS city,
	REGEX_EXTRACT(line, '\\"review_count\\"\\:\\s(.*?)\\,',1) AS (review_count:INT),
	REGEX_EXTRACT(line, '\\"name\\"\\:\\s\\"(.*?)\\"\\,',1) AS name,
	REGEX_EXTRACT(line, '\\"longitude\\"\\:\\s(.*?)\\,',1) AS (longitude:FLOAT),
	REGEX_EXTRACT(line, '\\"latitude\\"\\:\\s(.*?)\\,',1) AS (latitude:FLOAT),
	REGEX_EXTRACT(line, '\\"stars\\"\\:\\s(.*?)\\,',1) AS (stars:double),
	REGEX_EXTRACT(line, '\\"state\\"\\:\\s\\"(.*?)\\"\\,',1) AS state,
	REGEX_EXTRACT(line, '\\"type\\"\\:\\s\\"(.*?)\\"',1) AS type;

--generate zip code
business_json = FOREACH business_clean_3 GENERATE business_id, name, full_address, state, city, open, categories, type, review_count, stars, longitude, latitude, REGEX_EXTRACT(full_address, '(.*)\\,\\s(.*)',2) as zipcode;

--store into hdfs
STORE business_json INTO '/user/ppca/output/business_json_table' USING PigStorage('\u0001');


  
