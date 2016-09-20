--sample input:{"votes": {"funny": 0, "useful": 7, "cool": 0}, "user_id": "CR2y7yEm4X035ZMzrTtN9Q", "name": "Jim", "average_stars": 5.0, 
--"review_count": 6, "type": "user"}

--load data
user_raw_1 = LOAD '/user/ppca/yelp_training_set/yelp_training_set_user.json' USING JsonLoader('votes: tuple(funny:INT, useful:INT, cool:INT),user_id:CHARARRAY, name:CHARARRAY, average_stars: DOUBLE, review_count: INT, type:CHARARRAY');

--flatten votes
user_raw_2 = FOREACH user_raw_1 GENERATE FLATTEN(votes), user_id, name, average_stars, review_count, type;

--total votes
user_json = FOREACH user_raw_2 GENERATE $0 AS funny_votes, $1 AS useful_votes, $2 AS cool_votes, user_id, name, average_stars, review_count, type, (INT) (funny+cool+useful) AS total_votes;

--store pig table

STORE user_json INTO '/user/ppca/output/user_json_table' USING PigStorage('\u0001');
