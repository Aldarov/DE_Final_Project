create table if not exists raw_data (
	guid varchar(512) NULL,
	source_name varchar(128) NULL,
	link varchar(512) NULL,
	title varchar NULL,
	category varchar(256) NULL,
	pub_date timestamptz NULL
);
COMMENT ON TABLE raw_data IS 'Сырые данные';


create table if not exists categories (
	id int NOT NULL,
	"name" varchar(128) NOT NULL,
	CONSTRAINT categories_pk PRIMARY KEY (id)
);
COMMENT ON TABLE categories IS 'Категории новостей';

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
	id int NOT NULL,
	"name" varchar(128) NOT NULL,
	url_rss varchar(256) NOT null,
	CONSTRAINT sources_pk PRIMARY KEY (id)
);
COMMENT ON TABLE sources IS 'Источники данных';

insert into sources(id, name, url_rss)
values
	(1, 'lenta.ru', 'https://lenta.ru/rss'),
	(2, 'vedomosti.ru', 'https://www.vedomosti.ru/rss/news'),
	(3, 'tass.ru', 'https://tass.ru/rss/v2.xml');


create table if not exists source_categories (
	id int NOT NULL,
	source_id int NOT NULL,
	"name" varchar(128) NOT NULL,
	CONSTRAINT source_categories_pk PRIMARY KEY (id)
);
COMMENT ON TABLE source_categories IS 'Категории новостей источников данных';

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


create table if not exists categories_relationship (
	category_id int NOT NULL,
	source_category_id int NULL,
	CONSTRAINT categories_relationship_pk PRIMARY KEY (category_id, source_category_id),
	CONSTRAINT categories_relationship_fk_categories FOREIGN KEY (category_id) REFERENCES categories(id),
	CONSTRAINT categories_relationship_fk_source_categories FOREIGN KEY (source_category_id) REFERENCES source_categories(id)
);
COMMENT ON TABLE categories_relationship IS 'Взаимосвязь категорий новостей c категориями из разных источников данных';

insert into categories_relationship(category_id, source_category_id)
values
	(1, 1),
	(1, 2),
	(1, 3),
	(1, 4),
	(1, 15),
	(1, 33),
	(1, 34),
	(1, 35),
	(2, 5),
	(2, 36),
	(3, 6),
	(3, 16),
	(3, 37),
	(4, 7),
	(4, 8),
	(4, 17),
	(4, 18),
	(5, 9),
	(5, 10),
	(5, 19),
	(5, 20),
	(5, 21),
	(5, 22),
	(5, 23),
	(5, 24),
	(5, 25),
	(6, 11),
	(6, 26),
	(6, 27),
	(6, 38),
	(6, 39),
	(7, 12),
	(7, 28),
	(8, 13),
	(8, 29),
	(9, 14),
	(9, 30),
	(9, 31),
	(9, 40),
	(9, 41),
	(9, 42),
	(9, 43),
	(9, 44),
	(10, 7),
	(10, 32),
	(10, 45);

CREATE TABLE processed_data (
	news_id varchar(512) NOT NULL,
	category_id int NOT NULL,
	source_id int NOT NULL,
	pub_date timestamptz NOT NULL,
	link varchar(512) NULL,
	title varchar NULL,
	CONSTRAINT processed_data_pk PRIMARY KEY (news_id, category_id),
	CONSTRAINT processed_data_fk_categories FOREIGN KEY (category_id) REFERENCES categories(id),
	CONSTRAINT processed_data_fk_sources FOREIGN KEY (source_id) REFERENCES sources(id)
);
COMMENT ON TABLE processed_data IS 'Обработанные данные';

CREATE TABLE logs (
	id int NOT NULL GENERATED ALWAYS AS IDENTITY,
	error_date timestamptz NOT NULL,
	error_message varchar NOT NULL,
	stack_trace varchar NULL,
	CONSTRAINT logs_pk PRIMARY KEY (id)
);
COMMENT ON TABLE logs IS 'Логи';

CREATE TABLE news_by_category_showcase (
	category_id int NOT NULL,
	category_name varchar(128) NOT NULL,
	source_name varchar(128) NOT NULL,
	number_of_news_by_category int NULL,
	number_of_news_by_category_and_source int NULL,
	number_of_news_by_category_last_day int NULL,
	number_of_news_by_category_and_source_last_day int NULL,
	avg_number_of_news_by_category_per_day int NULL,
	day_with_max_number_of_news_by_category date NULL,
	news_count_on_mon int NULL,
	news_count_on_tue int NULL,
	news_count_on_wed int NULL,
	news_count_on_thu int NULL,
	news_count_on_fri int NULL,
	news_count_on_sat int NULL,
	news_count_on_sun int NULL
);
COMMENT ON TABLE news_by_category_showcase IS 'Витрина данных - анализ новостей по категориям';