create table if not exists raw_data (
    source varchar(100)
    link varchar(500),
    title varchar(max),
    category varchar(250),
    pub_date date,
);