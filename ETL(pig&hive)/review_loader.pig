--sample input:{"votes": {"funny": 0, "useful": 5, "cool": 2}, "user_id": "rLtl8ZkDX5vH5nAx9C3q5Q", "review_id": "fWKvX83p0-ka4JS3dc6E5A", "stars": 5, 
--"date": "2011-01-26", "text": "My wife took me here on my birthday for breakfast and it was excellent.  The weather was perfect which 
--made sitting outside overlooking their grounds an absolute pleasure.  Our waitress was excellent and our food arrived quickly on the "}

--load data

review_raw_1 = LOAD '/user/ppca/yelp_training_set/yelp_training_set_review.json' USING JsonLoader('votes:tuple(funny: INT, useful: INT, cool: INT), user_id:CHARARRAY, review_id: CHARARRAY, stars: INT, date: CHARARRAY, text: CHARARRAY');

--flatten votes
review_raw_2 = FOREACH review_raw_1 GENERATE FLATTEN(votes), user_id, review_id, stars, date, text;

--rename the votes feature and sum up the votes
review_json = FOREACH review_raw_2 GENERATE $0 AS funny_votes, $1 AS useful_votes, $2 AS cool_votes, user_id, review_id, stars, date, text, $0+$1+$2 AS total_votes;

--store pig table
STORE review_json INTO '/user/ppca/output/review_json_table' USING PigStorage('\u0001');
