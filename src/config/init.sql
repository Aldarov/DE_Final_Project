create table if not exists raw_data (
	guid varchar(512) not NULL,
	source_name varchar(128) NULL,
	link varchar(512) NULL,
	title varchar NULL,
	category varchar(256) NULL,
	pub_date timestamptz NULL
);