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

create table if not exists sources (
	id int4 NOT NULL,
	"name" varchar(128) NOT NULL,
	url_rss varchar(256) NOT null,
	CONSTRAINT sources_pk PRIMARY KEY (id)
);

insert into sources(id, name, url_rss)
values
	(1, 'lenta.ru', 'https://lenta.ru/rss'),
	(2, 'vedomosti.ru', 'https://www.vedomosti.ru/rss/news'),
	(3, 'tass.ru', 'https://tass.ru/rss/v2.xml');

create table if not exists source_categories (
	id int4 NOT NULL,
	source_id int4 NOT NULL,
	"name" varchar(128) NOT NULL,
	CONSTRAINT source_categories_pk PRIMARY KEY (id)
);

insert into source_categories(id, source_id, name)
values
	(1, 1, 'Забота о себе'),
	(2, 1, 'Из жизни'),
	(3, 1, 'Путешествия'),
	(4, 1, 'Среда обитания'),
	(5, 1, 'Интернет и СМИ'),
	(6, 1, 'Культура'),
	(7, 1, 'Мир'),
	(8, 1, 'Бывший СССР'),
	(9, 1, 'Моя страна'),
	(10, 1, 'Россия'),
	(11, 1, 'Наука и техника'),
	(12, 1, 'Силовые структуры'),
	(13, 1, 'Спорт'),
	(14, 1, 'Экономика');

insert into source_categories(id, source_id, name)
values
	(15, 2, 'Общество'),
	(16, 2, 'Культура'),
	(17, 2, 'Международная панорама'),
	(18, 2, 'Армия и ОПК'),
	(19, 2, 'В стране'),
	(20, 2, 'Москва'),
	(21, 2, 'Московская область'),
	(22, 2, 'Северо-Запад'),
	(23, 2, 'Новости Урала'),
	(24, 2, 'Сибирь'),
	(25, 2, 'Национальные проекты'),
	(26, 2, 'Наука'),
	(27, 2, 'Космос'),
	(28, 2, 'Происшествия'),
	(29, 2, 'Спорт'),
	(30, 2, 'Экономика и бизнес'),
	(31, 2, 'Малый бизнес'),
	(32, 2, 'Политика');

insert into source_categories(id, source_id, name)
values
	(33, 3, 'Общество'),
	(34, 3, 'Менеджмент'),
	(35, 3, 'Карьера'),
	(36, 3, 'Медиа'),
	(37, 3, 'Стиль жизни'),
	(38, 3, 'Технологии'),
	(39, 3, 'Авто'),
	(40, 3, 'Экономика'),
	(41, 3, 'Бизнес'),
	(42, 3, 'Финансы'),
	(43, 3, 'Инвестиции'),
	(44, 3, 'Личный счет'),
	(45, 3, 'Политика');
