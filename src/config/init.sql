create table if not exists raw_data (
	guid varchar(512) not NULL,
	source_name varchar(128) NULL,
	link varchar(512) NULL,
	title varchar NULL,
	category varchar(256) NULL,
	pub_date timestamptz NULL
);

create table if not exists categories (
	id int4 NOT NULL,
	"name" varchar(128) NOT NULL,
	CONSTRAINT categories_pk PRIMARY KEY (id)
);

insert into categories(id, name) values(1, 'Общество');
insert into categories(id, name) values(2, 'Интернет и СМИ');
insert into categories(id, name) values(3, 'Культура');
insert into categories(id, name) values(4, 'Международная панорама');
insert into categories(id, name) values(5, 'Моя страна');
insert into categories(id, name) values(6, 'Наука и техника');
insert into categories(id, name) values(7, 'Происшествия');
insert into categories(id, name) values(8, 'Спорт');
insert into categories(id, name) values(9, 'Экономика и бизнес');
insert into categories(id, name) values(10, 'Политика');
