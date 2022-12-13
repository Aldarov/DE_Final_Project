create table if not exists raw_data(
    source varchar(128),
    link varchar(512),
    title varchar,
    category varchar(256),
    pub_date date
);