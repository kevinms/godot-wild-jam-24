create table if not exists scores (
	score_id integer primary key,

	player_name text,
	spouse_name text,
	baby_name text,

	game_quality real,
	timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
