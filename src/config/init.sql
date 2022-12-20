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

INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/obstrel_dnr/',4,1,'2022-12-18 16:29:25+08','https://lenta.ru/news/2022/12/18/obstrel_dnr/','Пленный артиллерист ВСУ раскрыл подробности об обстреле Донецка'),
	 ('https://lenta.ru/news/2022/12/18/gas/',4,1,'2022-12-18 16:15:00+08','https://lenta.ru/news/2022/12/18/gas/','Отказ Молдавии от российского газа объяснили'),
	 ('https://lenta.ru/news/2022/12/18/covi/',5,1,'2022-12-18 16:08:00+08','https://lenta.ru/news/2022/12/18/covi/','В России выявили 7222 новых случая коронавируса'),
	 ('https://lenta.ru/news/2022/12/18/revansh/',8,1,'2022-12-18 16:08:00+08','https://lenta.ru/news/2022/12/18/revansh/','Российский боец UFC нацелился на реванш с Махачевым'),
	 ('https://lenta.ru/news/2022/12/18/arctic_attic/',4,1,'2022-12-18 16:03:00+08','https://lenta.ru/news/2022/12/18/arctic_attic/','В США признали лидерство России в арктическом регионе'),
	 ('https://lenta.ru/news/2022/12/18/arctic_attic/',10,1,'2022-12-18 16:03:00+08','https://lenta.ru/news/2022/12/18/arctic_attic/','В США признали лидерство России в арктическом регионе'),
	 ('https://lenta.ru/news/2022/12/18/polety/',1,1,'2022-12-18 16:03:00+08','https://lenta.ru/news/2022/12/18/polety/','Более 70 рейсов отменили и задержали в Москве из-за рекордного снегопада'),
	 ('https://lenta.ru/news/2022/12/18/klichko_teplosnabzh/',4,1,'2022-12-18 15:59:00+08','https://lenta.ru/news/2022/12/18/klichko_teplosnabzh/','В Киеве заявили о полном восстановлении систем теплоснабжения'),
	 ('https://lenta.ru/news/2022/12/18/pusk_is_pukto/',4,1,'2022-12-18 15:50:00+08','https://lenta.ru/news/2022/12/18/pusk_is_pukto/','В Южной Корее сообщили подробности пуска КНДР баллистических ракет'),
	 ('https://lenta.ru/news/2022/12/18/pusk_is_pukto/',10,1,'2022-12-18 15:50:00+08','https://lenta.ru/news/2022/12/18/pusk_is_pukto/','В Южной Корее сообщили подробности пуска КНДР баллистических ракет');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/spasatel/',6,1,'2022-12-18 15:41:00+08','https://lenta.ru/news/2022/12/18/spasatel/','Стала известна длительность полета корабля-спасателя к МКС'),
	 ('https://lenta.ru/news/2022/12/18/papa_frantsisk/',4,1,'2022-12-18 15:38:00+08','https://lenta.ru/news/2022/12/18/papa_frantsisk/','Папа Римский назвал конфликт на Украине «мировой войной»'),
	 ('https://lenta.ru/news/2022/12/18/papa_frantsisk/',10,1,'2022-12-18 15:38:00+08','https://lenta.ru/news/2022/12/18/papa_frantsisk/','Папа Римский назвал конфликт на Украине «мировой войной»'),
	 ('https://lenta.ru/news/2022/12/18/kotshimars/',4,1,'2022-12-18 15:36:00+08','https://lenta.ru/news/2022/12/18/kotshimars/','Военкор показал применением РСЗО HIMARS по позициям российских войск'),
	 ('https://lenta.ru/news/2022/12/18/salatiki/',1,1,'2022-12-18 15:20:00+08','https://lenta.ru/news/2022/12/18/salatiki/','Врач назвала россиянам безопасный срок хранения новогодних салатов'),
	 ('https://lenta.ru/news/2022/12/18/puma/',6,1,'2022-12-18 15:12:00+08','https://lenta.ru/news/2022/12/18/puma/','В Германии рассказали о проблемах с состоянием предназначенных для НАТО БМП Puma'),
	 ('https://lenta.ru/news/2022/12/18/ovechkin/',8,1,'2022-12-18 15:08:00+08','https://lenta.ru/news/2022/12/18/ovechkin/','Овечкин силовым приемом выбросил с площадки канадского хоккеиста'),
	 ('https://lenta.ru/news/2022/12/18/greece/',5,1,'2022-12-18 14:56:00+08','https://lenta.ru/news/2022/12/18/greece/','Постпред Крыма предостерег Грецию от передачи Украине комплексов С-300'),
	 ('https://lenta.ru/news/2022/12/18/said/',8,1,'2022-12-18 14:45:00+08','https://lenta.ru/news/2022/12/18/said/','Однофамилец Нурмагомедова одержал четвертую подряд победу в UFC'),
	 ('https://lenta.ru/news/2022/12/18/tynda/',7,1,'2022-12-18 14:35:00+08','https://lenta.ru/news/2022/12/18/tynda/','Экс-главу российского города арестовали по делу о злоупотреблениях полномочиями');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/ufc/',8,1,'2022-12-18 14:24:00+08','https://lenta.ru/news/2022/12/18/ufc/','Российский боец одержал победу на турнире UFC'),
	 ('https://lenta.ru/news/2022/12/18/car-fr_ru/',4,1,'2022-12-18 14:21:00+08','https://lenta.ru/news/2022/12/18/car-fr_ru/','Посол ЦАР ответил на заявления главы МИД Франции о взрыве в Русском доме'),
	 ('https://lenta.ru/news/2022/12/18/car-fr_ru/',10,1,'2022-12-18 14:21:00+08','https://lenta.ru/news/2022/12/18/car-fr_ru/','Посол ЦАР ответил на заявления главы МИД Франции о взрыве в Русском доме'),
	 ('https://lenta.ru/news/2022/12/18/sneg/',5,1,'2022-12-18 14:14:00+08','https://lenta.ru/news/2022/12/18/sneg/','В российском городе снегоуборочная машина засыпала ребенка'),
	 ('https://lenta.ru/news/2022/12/18/pistol/',5,1,'2022-12-18 14:11:00+08','https://lenta.ru/news/2022/12/18/pistol/','В Санкт-Петербурге мужчина расстрелял подростков из пистолета'),
	 ('https://lenta.ru/news/2022/12/18/french/',5,1,'2022-12-18 14:00:45+08','https://lenta.ru/news/2022/12/18/french/','В Томске издали книгу французского путешественника о Сибири'),
	 ('https://lenta.ru/news/2022/12/18/gripp/',5,1,'2022-12-18 13:43:00+08','https://lenta.ru/news/2022/12/18/gripp/','Вирусолог предрек спад заболеваемости гриппом после новогодних праздников'),
	 ('https://lenta.ru/news/2022/12/18/su35/',5,1,'2022-12-18 13:39:52+08','https://lenta.ru/news/2022/12/18/su35/','Работу истребителя Су-35 ВКС России на Украине показали на видео'),
	 ('https://lenta.ru/news/2022/12/18/independence/',9,1,'2022-12-18 13:38:00+08','https://lenta.ru/news/2022/12/18/independence/','Молдавия заявила о достижении независимости от российского газа'),
	 ('https://lenta.ru/news/2022/12/18/patrushev_burns/',4,1,'2022-12-18 13:27:00+08','https://lenta.ru/news/2022/12/18/patrushev_burns/','Патрушев и Бернс на встрече в Москве обсуждали российскую армию и Украину');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/patrushev_burns/',10,1,'2022-12-18 13:27:00+08','https://lenta.ru/news/2022/12/18/patrushev_burns/','Патрушев и Бернс на встрече в Москве обсуждали российскую армию и Украину'),
	 ('https://lenta.ru/news/2022/12/18/dnc/',5,1,'2022-12-18 13:13:00+08','https://lenta.ru/news/2022/12/18/dnc/','Выпущенный ВСУ снаряд попал на территорию гостиницы в Донецке'),
	 ('https://lenta.ru/news/2022/12/18/rekord/',1,1,'2022-12-18 13:07:00+08','https://lenta.ru/news/2022/12/18/rekord/','Москвичей предупредили о рекордном снегопаде'),
	 ('https://lenta.ru/news/2022/12/18/gamak/',5,1,'2022-12-18 12:57:50+08','https://lenta.ru/news/2022/12/18/gamak/','Запутавшегося в гамаке подростка вывели из комы'),
	 ('https://lenta.ru/news/2022/12/18/lnr/',5,1,'2022-12-18 12:45:00+08','https://lenta.ru/news/2022/12/18/lnr/','В ЛНР назвали политической ошибкой включение Донбасса в УССР'),
	 ('https://lenta.ru/news/2022/12/18/can_not_handle/',4,1,'2022-12-18 12:41:00+08','https://lenta.ru/news/2022/12/18/can_not_handle/','Украинская беженка не смогла вынести условия жизни в британской квартире'),
	 ('https://lenta.ru/news/2022/12/18/but/',5,1,'2022-12-18 12:39:00+08','https://lenta.ru/news/2022/12/18/but/','Слуцкий рассказал об угрозе обстрела ВСУ во время поездки с Бутом в Луганск'),
	 ('https://lenta.ru/news/2022/12/18/port/',9,1,'2022-12-18 12:35:36+08','https://lenta.ru/news/2022/12/18/port/','Крым решил предложить свои порты Белоруссии в качестве ворот ЕАЭС'),
	 ('https://lenta.ru/news/2022/12/18/svyazi/',4,1,'2022-12-18 12:07:05+08','https://lenta.ru/news/2022/12/18/svyazi/','Британский адмирал выступил за более прочные связи с Россией'),
	 ('https://lenta.ru/news/2022/12/18/svyazi/',10,1,'2022-12-18 12:07:05+08','https://lenta.ru/news/2022/12/18/svyazi/','Британский адмирал выступил за более прочные связи с Россией');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/alp/',5,1,'2022-12-18 12:07:00+08','https://lenta.ru/news/2022/12/18/alp/','Умерла «лыжная бабушка Камчатки» альпинистка Людмила Аграновская'),
	 ('https://lenta.ru/news/2022/12/18/alimony/',5,1,'2022-12-18 12:03:10+08','https://lenta.ru/news/2022/12/18/alimony/','Россиянкам рассказали о возможности законно взыскать алименты мужа с его друзей'),
	 ('https://lenta.ru/news/2022/12/18/hakimiinfantino/',8,1,'2022-12-18 12:02:33+08','https://lenta.ru/news/2022/12/18/hakimiinfantino/','Стали известны подробности конфликта марокканского игрока и главы ФИФА'),
	 ('https://lenta.ru/news/2022/12/18/kimushka/',4,1,'2022-12-18 11:57:06+08','https://lenta.ru/news/2022/12/18/kimushka/','Ким Чен Ын с сестрой пропустили годовщину смерти отца'),
	 ('https://lenta.ru/news/2022/12/18/kimushka/',10,1,'2022-12-18 11:57:06+08','https://lenta.ru/news/2022/12/18/kimushka/','Ким Чен Ын с сестрой пропустили годовщину смерти отца'),
	 ('https://lenta.ru/news/2022/12/18/pridnestrovie/',4,1,'2022-12-18 11:45:35+08','https://lenta.ru/news/2022/12/18/pridnestrovie/','В Приднестровье обвинили Молдавию в дефиците лекарств'),
	 ('https://lenta.ru/news/2022/12/18/rdk/',4,1,'2022-12-18 11:39:00+08','https://lenta.ru/news/2022/12/18/rdk/','Глава британского генштаба заявил о контакте с Герасимовым в течение года'),
	 ('https://lenta.ru/news/2022/12/18/rdk/',10,1,'2022-12-18 11:39:00+08','https://lenta.ru/news/2022/12/18/rdk/','Глава британского генштаба заявил о контакте с Герасимовым в течение года'),
	 ('https://lenta.ru/news/2022/12/18/pope/',8,1,'2022-12-18 11:26:08+08','https://lenta.ru/news/2022/12/18/pope/','Папа Римский отказался смотреть финал ЧМ по футболу из-за обета'),
	 ('https://lenta.ru/news/2022/12/18/ms22/',6,1,'2022-12-18 11:12:38+08','https://lenta.ru/news/2022/12/18/ms22/','Российский космонавт оценил ситуацию на «Союзе»');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/fallen/',8,1,'2022-12-18 10:45:00+08','https://lenta.ru/news/2022/12/18/fallen/','Названа причина смерти 18-летнего российского хоккеиста канадского клуба'),
	 ('https://lenta.ru/news/2022/12/18/emergency/',4,1,'2022-12-18 10:34:56+08','https://lenta.ru/news/2022/12/18/emergency/','На границе США и Мексики ввели чрезвычайное положение из-за мигрантов'),
	 ('https://lenta.ru/news/2022/12/18/emergency/',10,1,'2022-12-18 10:34:56+08','https://lenta.ru/news/2022/12/18/emergency/','На границе США и Мексики ввели чрезвычайное положение из-за мигрантов'),
	 ('https://lenta.ru/news/2022/12/18/antonov/',4,1,'2022-12-18 10:34:00+08','https://lenta.ru/news/2022/12/18/antonov/','Посол Антонов объяснил отношение США к России'),
	 ('https://lenta.ru/news/2022/12/18/antonov/',10,1,'2022-12-18 10:34:00+08','https://lenta.ru/news/2022/12/18/antonov/','Посол Антонов объяснил отношение США к России'),
	 ('https://lenta.ru/news/2022/12/18/rct/',4,1,'2022-12-18 10:33:00+08','https://lenta.ru/news/2022/12/18/rct/','В Японии сообщили о пуске баллистической ракеты Северной Кореей'),
	 ('https://lenta.ru/news/2022/12/18/rct/',10,1,'2022-12-18 10:33:00+08','https://lenta.ru/news/2022/12/18/rct/','В Японии сообщили о пуске баллистической ракеты Северной Кореей'),
	 ('https://lenta.ru/news/2022/12/18/ottepel/',1,1,'2022-12-18 10:09:47+08','https://lenta.ru/news/2022/12/18/ottepel/','Москвичам назвали дату начала оттепели в Москве'),
	 ('https://lenta.ru/news/2022/12/18/sch/',4,1,'2022-12-18 10:07:00+08','https://lenta.ru/news/2022/12/18/sch/','Шольц объяснил отказ от поставок танков на Украину'),
	 ('https://lenta.ru/news/2022/12/18/sch/',10,1,'2022-12-18 10:07:00+08','https://lenta.ru/news/2022/12/18/sch/','Шольц объяснил отказ от поставок танков на Украину');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/sam/',5,1,'2022-12-18 10:06:00+08','https://lenta.ru/news/2022/12/18/sam/','Шойгу проинспектировал российские войска в зоне СВО'),
	 ('https://lenta.ru/news/2022/12/18/bank/',9,1,'2022-12-18 10:03:00+08','https://lenta.ru/news/2022/12/18/bank/','Россиян предостерегли о банковских уловках при открытии предновогоднего депозита'),
	 ('https://lenta.ru/news/2022/12/18/semeyka/',1,1,'2022-12-18 09:43:34+08','https://lenta.ru/news/2022/12/18/semeyka/','Гарри и Меган захотели извинений от королевской семьи'),
	 ('https://lenta.ru/news/2022/12/18/nuts/',6,1,'2022-12-18 09:31:50+08','https://lenta.ru/news/2022/12/18/nuts/','Грецкий орех уменьшил проявления стресса'),
	 ('https://lenta.ru/news/2022/12/18/dogs/',1,1,'2022-12-18 09:19:44+08','https://lenta.ru/news/2022/12/18/dogs/','Кинологи перечислили самые популярные породы собак в России в текущем году'),
	 ('https://lenta.ru/news/2022/12/18/critical_vulnerability/',4,1,'2022-12-18 09:09:00+08','https://lenta.ru/news/2022/12/18/critical_vulnerability/','В США заявили о критической уязвимости страны в восполнении арсеналов'),
	 ('https://lenta.ru/news/2022/12/18/critical_vulnerability/',10,1,'2022-12-18 09:09:00+08','https://lenta.ru/news/2022/12/18/critical_vulnerability/','В США заявили о критической уязвимости страны в восполнении арсеналов'),
	 ('https://lenta.ru/news/2022/12/18/shampus/',9,1,'2022-12-18 09:03:00+08','https://lenta.ru/news/2022/12/18/shampus/','Роскачество назвало признаки качественного шампанского'),
	 ('https://lenta.ru/news/2022/12/18/obm/',5,1,'2022-12-18 08:35:00+08','https://lenta.ru/news/2022/12/18/obm/','Названы кандидаты на возможный обмен заключенными между Россией и США'),
	 ('https://lenta.ru/news/2022/12/18/danger/',4,1,'2022-12-18 08:32:00+08','https://lenta.ru/news/2022/12/18/danger/','Европе спрогнозировали торговую войну с США');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/danger/',10,1,'2022-12-18 08:32:00+08','https://lenta.ru/news/2022/12/18/danger/','Европе спрогнозировали торговую войну с США'),
	 ('https://lenta.ru/news/2022/12/18/riga/',4,1,'2022-12-18 08:24:37+08','https://lenta.ru/news/2022/12/18/riga/','В Риге смогли переименовать в честь Украины улицу с посольством России'),
	 ('https://lenta.ru/news/2022/12/18/negotovy/',4,1,'2022-12-18 08:16:45+08','https://lenta.ru/news/2022/12/18/negotovy/','ЦРУ не увидело готовности России применить тактическое ядерное оружие'),
	 ('https://lenta.ru/news/2022/12/18/negotovy/',10,1,'2022-12-18 08:16:45+08','https://lenta.ru/news/2022/12/18/negotovy/','ЦРУ не увидело готовности России применить тактическое ядерное оружие'),
	 ('https://lenta.ru/news/2022/12/18/credit/',9,1,'2022-12-18 07:59:11+08','https://lenta.ru/news/2022/12/18/credit/','Россиянам рассказали о возможности попросить банк простить долг'),
	 ('https://lenta.ru/news/2022/12/18/ldkl/',5,1,'2022-12-18 07:54:00+08','https://lenta.ru/news/2022/12/18/ldkl/','Глава «Росатома» заявил о потребности в новой модели использования ледоколов'),
	 ('https://lenta.ru/news/2022/12/18/gerasimov/',4,1,'2022-12-18 07:39:41+08','https://lenta.ru/news/2022/12/18/gerasimov/','NYT узнала о планах Украины совершить покушение на Герасимова'),
	 ('https://lenta.ru/news/2022/12/18/gerasimov/',10,1,'2022-12-18 07:39:41+08','https://lenta.ru/news/2022/12/18/gerasimov/','NYT узнала о планах Украины совершить покушение на Герасимова'),
	 ('https://lenta.ru/news/2022/12/18/iran/',4,1,'2022-12-18 07:30:00+08','https://lenta.ru/news/2022/12/18/iran/','В Иране арестовали актрису из оскароносного фильма за поддержку протестов'),
	 ('https://lenta.ru/news/2022/12/18/iran/',10,1,'2022-12-18 07:30:00+08','https://lenta.ru/news/2022/12/18/iran/','В Иране арестовали актрису из оскароносного фильма за поддержку протестов');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/lack_of_pills/',4,1,'2022-12-18 07:10:36+08','https://lenta.ru/news/2022/12/18/lack_of_pills/','В Германии заявили о нехватке лекарств и жаропонижающих для детей'),
	 ('https://lenta.ru/news/2022/12/18/lack_of_pills/',10,1,'2022-12-18 07:10:36+08','https://lenta.ru/news/2022/12/18/lack_of_pills/','В Германии заявили о нехватке лекарств и жаропонижающих для детей'),
	 ('https://lenta.ru/news/2022/12/18/arst/',4,1,'2022-12-18 07:02:00+08','https://lenta.ru/news/2022/12/18/arst/','В офисе Зеленского подтвердили попытку покушения на Герасимова'),
	 ('https://lenta.ru/news/2022/12/18/telegram/',2,1,'2022-12-18 06:39:00+08','https://lenta.ru/news/2022/12/18/telegram/','Россиянам дали советы по защите от кражи аккаунтов в Telegram'),
	 ('https://lenta.ru/news/2022/12/18/himars/',5,1,'2022-12-18 06:30:00+08','https://lenta.ru/news/2022/12/18/himars/','В ЛНР рассказали о несовершенстве американских ракет HIMARS'),
	 ('https://lenta.ru/news/2022/12/18/psll/',4,1,'2022-12-18 06:21:00+08','https://lenta.ru/news/2022/12/18/psll/','Посол покинул съезд партии в Сербии после видео с обвинениями в адрес России'),
	 ('https://lenta.ru/news/2022/12/18/psll/',10,1,'2022-12-18 06:21:00+08','https://lenta.ru/news/2022/12/18/psll/','Посол покинул съезд партии в Сербии после видео с обвинениями в адрес России'),
	 ('https://lenta.ru/news/2022/12/18/electro/',4,1,'2022-12-18 06:20:00+08','https://lenta.ru/news/2022/12/18/electro/','Ситуацию с электроснабжением в Киеве назвали критической'),
	 ('https://lenta.ru/news/2022/12/18/hope/',2,1,'2022-12-18 05:53:01+08','https://lenta.ru/news/2022/12/18/hope/','Канадская журналистка понадеялась на достижение Россией цели спецоперации'),
	 ('https://lenta.ru/news/2022/12/18/vozm/',2,1,'2022-12-18 05:47:18+08','https://lenta.ru/news/2022/12/18/vozm/','Французы возмутились заявлением Макрона о санкциях против России');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/biden/',4,1,'2022-12-18 05:44:00+08','https://lenta.ru/news/2022/12/18/biden/','Команда Байдена начала подготовку к его предвыборной кампании'),
	 ('https://lenta.ru/news/2022/12/18/biden/',10,1,'2022-12-18 05:44:00+08','https://lenta.ru/news/2022/12/18/biden/','Команда Байдена начала подготовку к его предвыборной кампании'),
	 ('https://lenta.ru/news/2022/12/18/plbd/',4,1,'2022-12-18 05:35:00+08','https://lenta.ru/news/2022/12/18/plbd/','Байдена предложили судить за убийство мирного населения в Донбассе'),
	 ('https://lenta.ru/news/2022/12/18/plbd/',10,1,'2022-12-18 05:35:00+08','https://lenta.ru/news/2022/12/18/plbd/','Байдена предложили судить за убийство мирного населения в Донбассе'),
	 ('https://lenta.ru/news/2022/12/18/exercise/',6,1,'2022-12-18 05:29:16+08','https://lenta.ru/news/2022/12/18/exercise/','Упражнения снизили риск тяжелой коронавирусной инфекции'),
	 ('https://lenta.ru/news/2022/12/17/hakimi/',8,1,'2022-12-18 05:24:32+08','https://lenta.ru/news/2022/12/17/hakimi/','Игрок сборной Марокко оскорбил главу ФИФА после поражения на чемпионате мира'),
	 ('https://lenta.ru/news/2022/12/17/lights_off/',4,1,'2022-12-18 05:05:57+08','https://lenta.ru/news/2022/12/17/lights_off/','В Кривом Роге начались экстренные отключения света'),
	 ('https://lenta.ru/news/2022/12/17/less_than_one_percent/',9,1,'2022-12-18 04:59:34+08','https://lenta.ru/news/2022/12/17/less_than_one_percent/','Названа единственная расходующая больше одного процента ВВП на Украину страна'),
	 ('https://lenta.ru/news/2022/12/17/elka/',1,1,'2022-12-18 04:47:10+08','https://lenta.ru/news/2022/12/17/elka/','Российские чиновники украли ель с участка пенсионера и установили ее на площади'),
	 ('https://lenta.ru/news/2022/12/17/accident/',5,1,'2022-12-18 04:32:31+08','https://lenta.ru/news/2022/12/17/accident/','Зрительница пострадала от падения в оркестровую яму Саратовской консерватории');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/voda/',4,1,'2022-12-18 04:23:00+08','https://lenta.ru/news/2022/12/17/voda/','Зеленский заявил о проблемах с водоснабжением на Украине'),
	 ('https://lenta.ru/news/2022/12/17/benzema/',8,1,'2022-12-18 04:21:18+08','https://lenta.ru/news/2022/12/17/benzema/','Бензема отказался от предложения Макрона посетить финал чемпионата мира'),
	 ('https://lenta.ru/news/2022/12/17/mironov/',5,1,'2022-12-18 04:14:06+08','https://lenta.ru/news/2022/12/17/mironov/','Миронов высказался о санкциях ЕС против политических партий России'),
	 ('https://lenta.ru/news/2022/12/17/temp_record/',1,1,'2022-12-18 04:11:00+08','https://lenta.ru/news/2022/12/17/temp_record/','Температурный рекорд дня 85-летней давности побит в Крыму'),
	 ('https://lenta.ru/news/2022/12/17/geras/',5,1,'2022-12-18 03:50:38+08','https://lenta.ru/news/2022/12/17/geras/','NYT узнала о планах Украины совершить убийство начальника Генштаба РФ Герасимова'),
	 ('https://lenta.ru/news/2022/12/17/russia_decided_to_win/',5,1,'2022-12-18 03:36:29+08','https://lenta.ru/news/2022/12/17/russia_decided_to_win/','В Крыму заявили о решимости России довести спецоперацию до победы'),
	 ('https://lenta.ru/news/2022/12/17/kazbekov/',8,1,'2022-12-18 03:29:40+08','https://lenta.ru/news/2022/12/17/kazbekov/','Российский хоккеист канадского клуба умер в 18 лет'),
	 ('https://lenta.ru/news/2022/12/17/ven/',4,1,'2022-12-18 03:26:00+08','https://lenta.ru/news/2022/12/17/ven/','Бывший американский военный констатировал проигрыш Украины в конфликте с Россией'),
	 ('https://lenta.ru/news/2022/12/17/ven/',10,1,'2022-12-18 03:26:00+08','https://lenta.ru/news/2022/12/17/ven/','Бывший американский военный констатировал проигрыш Украины в конфликте с Россией'),
	 ('https://lenta.ru/news/2022/12/17/glava/',4,1,'2022-12-18 03:22:00+08','https://lenta.ru/news/2022/12/17/glava/','Посольство РФ рассказало о состоянии главы Русского дома в ЦАР после покушения');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/glava/',10,1,'2022-12-18 03:22:00+08','https://lenta.ru/news/2022/12/17/glava/','Посольство РФ рассказало о состоянии главы Русского дома в ЦАР после покушения'),
	 ('https://lenta.ru/news/2022/12/17/police/',7,1,'2022-12-18 03:01:59+08','https://lenta.ru/news/2022/12/17/police/','Полиция начала проверку по факту избиения замглавы ЖКХ Москвы'),
	 ('https://lenta.ru/news/2022/12/17/nene/',4,1,'2022-12-18 02:53:30+08','https://lenta.ru/news/2022/12/17/nene/','Шольц назвал три причины не поставлять танки на Украину'),
	 ('https://lenta.ru/news/2022/12/17/nene/',10,1,'2022-12-18 02:53:30+08','https://lenta.ru/news/2022/12/17/nene/','Шольц назвал три причины не поставлять танки на Украину'),
	 ('https://lenta.ru/news/2022/12/17/tours/',1,1,'2022-12-18 02:51:19+08','https://lenta.ru/news/2022/12/17/tours/','Туры в Египет из России будут перебронироваться по соглашению сторон'),
	 ('https://lenta.ru/news/2022/12/17/eerrd/',4,1,'2022-12-18 02:47:00+08','https://lenta.ru/news/2022/12/17/eerrd/','Эрдоган заявил о желании оппозиции устроить «игру престолов»'),
	 ('https://lenta.ru/news/2022/12/17/eerrd/',10,1,'2022-12-18 02:47:00+08','https://lenta.ru/news/2022/12/17/eerrd/','Эрдоган заявил о желании оппозиции устроить «игру престолов»'),
	 ('https://lenta.ru/news/2022/12/17/oil_looser/',9,1,'2022-12-18 02:36:22+08','https://lenta.ru/news/2022/12/17/oil_looser/','В США рассказали о проигравших от потолка цен на российскую нефть'),
	 ('https://lenta.ru/news/2022/12/17/regragui/',8,1,'2022-12-18 02:29:00+08','https://lenta.ru/news/2022/12/17/regragui/','Тренер сборной Марокко прокомментировал поражение команды в матче с Хорватией'),
	 ('https://lenta.ru/news/2022/12/17/dalic/',8,1,'2022-12-18 02:06:00+08','https://lenta.ru/news/2022/12/17/dalic/','Тренер сборной Хорватии оценил третье место команды на чемпионате мира');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/bestplayer/',8,1,'2022-12-18 02:00:00+08','https://lenta.ru/news/2022/12/17/bestplayer/','Назван лучший игрок матча за третье место на чемпионате мира'),
	 ('https://lenta.ru/news/2022/12/17/briteconom/',9,1,'2022-12-18 01:55:00+08','https://lenta.ru/news/2022/12/17/briteconom/','Британцев попросили снизить температуру в бойлерах для экономии'),
	 ('https://lenta.ru/news/2022/12/17/tg/',2,1,'2022-12-18 01:47:20+08','https://lenta.ru/news/2022/12/17/tg/','Интерес мошенников к угону аккаунтов в Telegram объяснили'),
	 ('https://lenta.ru/news/2022/12/17/energobloki/',4,1,'2022-12-18 01:40:00+08','https://lenta.ru/news/2022/12/17/energobloki/','В «Энергоатоме» заявили о подключении к сети подконтрольных Киеву энергоблоков'),
	 ('https://lenta.ru/news/2022/12/17/rock/',4,1,'2022-12-18 01:28:35+08','https://lenta.ru/news/2022/12/17/rock/','Орбан назвал строительство подводного электропровода «настоящим рок-н-роллом»'),
	 ('https://lenta.ru/news/2022/12/17/krlim/',5,1,'2022-12-17 20:37:00+08','https://lenta.ru/news/2022/12/17/krlim/','Российские военные поразили резервы ВСУ в ДНР'),
	 ('https://lenta.ru/news/2022/12/17/rock/',10,1,'2022-12-18 01:28:35+08','https://lenta.ru/news/2022/12/17/rock/','Орбан назвал строительство подводного электропровода «настоящим рок-н-роллом»'),
	 ('https://lenta.ru/news/2022/12/17/trkgrc/',4,1,'2022-12-18 01:16:27+08','https://lenta.ru/news/2022/12/17/trkgrc/','Минобороны Турции обвинило Грецию в попытке перехвата военных самолетов'),
	 ('https://lenta.ru/news/2022/12/17/trkgrc/',10,1,'2022-12-18 01:16:27+08','https://lenta.ru/news/2022/12/17/trkgrc/','Минобороны Турции обвинило Грецию в попытке перехвата военных самолетов'),
	 ('https://lenta.ru/news/2022/12/17/vietnam/',2,1,'2022-12-18 01:06:08+08','https://lenta.ru/news/2022/12/17/vietnam/','Ситуацию на Украине назвали «вторым Вьетнамом» для США');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/croatiamorocco/',8,1,'2022-12-18 00:55:00+08','https://lenta.ru/news/2022/12/17/croatiamorocco/','Сборная Хорватии стала бронзовым призером чемпионата мира'),
	 ('https://lenta.ru/news/2022/12/17/sireny_trevogi/',4,1,'2022-12-18 00:50:31+08','https://lenta.ru/news/2022/12/17/sireny_trevogi/','В четырех областях Украины прозвучала воздушная тревога'),
	 ('https://lenta.ru/news/2022/12/17/ustoichivost/',4,1,'2022-12-18 00:35:58+08','https://lenta.ru/news/2022/12/17/ustoichivost/','Влияние погоды на устойчивость энергосистемы Украины объяснили'),
	 ('https://lenta.ru/news/2022/12/17/germmoroz/',9,1,'2022-12-18 00:32:23+08','https://lenta.ru/news/2022/12/17/germmoroz/','План Германии по экономии газа оказался под угрозой из-за морозов'),
	 ('https://lenta.ru/news/2022/12/17/pokhishchennyye_sokrovishcha/',1,1,'2022-12-18 00:24:26+08','https://lenta.ru/news/2022/12/17/pokhishchennyye_sokrovishcha/','В Германии нашли значительную часть похищенных из дрезденского музея сокровищ'),
	 ('https://lenta.ru/news/2022/12/17/letzte/',1,1,'2022-12-18 00:16:36+08','https://lenta.ru/news/2022/12/17/letzte/','Экоактивисты в Берлине приклеили себя к дороге'),
	 ('https://lenta.ru/news/2022/12/17/nsm/',3,1,'2022-12-18 00:04:14+08','https://lenta.ru/news/2022/12/17/nsm/','Михалков прокомментировал попадание в санкционный список Евросоюза'),
	 ('https://lenta.ru/news/2022/12/17/fail/',4,1,'2022-12-18 00:02:28+08','https://lenta.ru/news/2022/12/17/fail/','Жена Зеленского сорвала «крещение» военного корабля'),
	 ('https://lenta.ru/news/2022/12/17/urkenerg/',4,1,'2022-12-17 23:57:50+08','https://lenta.ru/news/2022/12/17/urkenerg/','Власти украинского региона оценили ситуацию с энергоснабжением'),
	 ('https://lenta.ru/news/2022/12/17/shlemenko/',8,1,'2022-12-17 23:53:08+08','https://lenta.ru/news/2022/12/17/shlemenko/','Шлеменко дал совет проигравшему в бою с блогером Александру Емельяненко');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/oruzie/',4,1,'2022-12-17 23:41:00+08','https://lenta.ru/news/2022/12/17/oruzie/','В США заявили о риске истощения своего арсенала из-за Украины'),
	 ('https://lenta.ru/news/2022/12/17/oruzie/',10,1,'2022-12-17 23:41:00+08','https://lenta.ru/news/2022/12/17/oruzie/','В США заявили о риске истощения своего арсенала из-за Украины'),
	 ('https://lenta.ru/news/2022/12/17/priostcenz/',4,1,'2022-12-17 23:34:00+08','https://lenta.ru/news/2022/12/17/priostcenz/','В МИД отреагировали на приостановку лицензий русскоязычных каналов в Молдавии'),
	 ('https://lenta.ru/news/2022/12/17/priostcenz/',10,1,'2022-12-17 23:34:00+08','https://lenta.ru/news/2022/12/17/priostcenz/','В МИД отреагировали на приостановку лицензий русскоязычных каналов в Молдавии'),
	 ('https://lenta.ru/news/2022/12/17/kdrv/',5,1,'2022-12-17 23:32:00+08','https://lenta.ru/news/2022/12/17/kdrv/','Кадыров сообщил об успешной атаке в зоне СВО'),
	 ('https://lenta.ru/news/2022/12/17/napadenie/',7,1,'2022-12-17 23:26:41+08','https://lenta.ru/news/2022/12/17/napadenie/','В Москве напали на замглавы департамента ЖКХ'),
	 ('https://lenta.ru/news/2022/12/17/telegram/',5,1,'2022-12-17 23:26:00+08','https://lenta.ru/news/2022/12/17/telegram/','Минцифры предупредило о массовых кражах аккаунтов в Telegram'),
	 ('https://lenta.ru/news/2022/12/17/bolg/',4,1,'2022-12-17 23:25:11+08','https://lenta.ru/news/2022/12/17/bolg/','Болгары призвали президента передумать направлять оружие Украине'),
	 ('https://lenta.ru/news/2022/12/17/bolg/',10,1,'2022-12-17 23:25:11+08','https://lenta.ru/news/2022/12/17/bolg/','Болгары призвали президента передумать направлять оружие Украине'),
	 ('https://lenta.ru/news/2022/12/17/china/',4,1,'2022-12-17 23:04:40+08','https://lenta.ru/news/2022/12/17/china/','Десятки стран потребовали от США разъяснений по торговой политике');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/china/',10,1,'2022-12-17 23:04:40+08','https://lenta.ru/news/2022/12/17/china/','Десятки стран потребовали от США разъяснений по торговой политике'),
	 ('https://lenta.ru/news/2022/12/17/novakpr/',4,1,'2022-12-17 23:01:39+08','https://lenta.ru/news/2022/12/17/novakpr/','Президент Венгрии выступила против отрицания русской культуры'),
	 ('https://lenta.ru/news/2022/12/17/novakpr/',10,1,'2022-12-17 23:01:39+08','https://lenta.ru/news/2022/12/17/novakpr/','Президент Венгрии выступила против отрицания русской культуры'),
	 ('https://lenta.ru/news/2022/12/17/pozar/',5,1,'2022-12-17 22:55:50+08','https://lenta.ru/news/2022/12/17/pozar/','Стали известны подробности мощного пожара во Владивостоке'),
	 ('https://lenta.ru/news/2022/12/17/vidrakudar/',4,1,'2022-12-17 22:55:03+08','https://lenta.ru/news/2022/12/17/vidrakudar/','Появилось видео с пораженной ракетными ударами украинской подстанции'),
	 ('https://lenta.ru/news/2022/12/17/scaloni/',8,1,'2022-12-17 22:55:00+08','https://lenta.ru/news/2022/12/17/scaloni/','Тренер сборной Аргентины высказался о будущем Месси в команде'),
	 ('https://lenta.ru/news/2022/12/17/usakonfl/',4,1,'2022-12-17 22:47:00+08','https://lenta.ru/news/2022/12/17/usakonfl/','Китайцы обвинили США в затягивании российско-украинского конфликта'),
	 ('https://lenta.ru/news/2022/12/17/usakonfl/',10,1,'2022-12-17 22:47:00+08','https://lenta.ru/news/2022/12/17/usakonfl/','Китайцы обвинили США в затягивании российско-украинского конфликта'),
	 ('https://lenta.ru/news/2022/12/17/alco/',4,1,'2022-12-17 22:39:00+08','https://lenta.ru/news/2022/12/17/alco/','В Индии около 80 человек скончались из-за суррогатного алкоголя'),
	 ('https://lenta.ru/news/2022/12/17/alco/',10,1,'2022-12-17 22:39:00+08','https://lenta.ru/news/2022/12/17/alco/','В Индии около 80 человек скончались из-за суррогатного алкоголя');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/sodakivid/',7,1,'2022-12-17 22:31:50+08','https://lenta.ru/news/2022/12/17/sodakivid/','Нападение стаи бродячих собак на российских подростков попало на видео'),
	 ('https://lenta.ru/news/2022/12/17/redw/',1,1,'2022-12-17 22:24:00+08','https://lenta.ru/news/2022/12/17/redw/','Застрявших в Египте российских туристов вывезут другой авиакомпанией'),
	 ('https://lenta.ru/news/2022/12/17/drone/',5,1,'2022-12-17 22:22:00+08','https://lenta.ru/news/2022/12/17/drone/','Пушилин заявил об участии США в модернизации украинских беспилотников'),
	 ('https://lenta.ru/news/2022/12/17/megangarri/',1,1,'2022-12-17 22:15:00+08','https://lenta.ru/news/2022/12/17/megangarri/','Стало известно о возможном приглашении принца Чарльза для Гарри и Меган Маркл'),
	 ('https://lenta.ru/news/2022/12/17/isnavt/',7,1,'2022-12-17 21:51:00+08','https://lenta.ru/news/2022/12/17/isnavt/','Россиянина осудили на восемь лет за изнасилование девочки в салоне автомобиля'),
	 ('https://lenta.ru/news/2022/12/17/crazy_fans/',8,1,'2022-12-17 21:50:00+08','https://lenta.ru/news/2022/12/17/crazy_fans/','В Австралии фанаты выбежали на поле во время матча и подрались с футболистами'),
	 ('https://lenta.ru/news/2022/12/17/sunak_uk/',4,1,'2022-12-17 21:42:00+08','https://lenta.ru/news/2022/12/17/sunak_uk/','Сунак отказался от плана Трасс по закупке иностранной электроэнергии'),
	 ('https://lenta.ru/news/2022/12/17/sunak_uk/',10,1,'2022-12-17 21:42:00+08','https://lenta.ru/news/2022/12/17/sunak_uk/','Сунак отказался от плана Трасс по закупке иностранной электроэнергии'),
	 ('https://lenta.ru/news/2022/12/17/povedeniye_zelenskogo/',4,1,'2022-12-17 21:41:00+08','https://lenta.ru/news/2022/12/17/povedeniye_zelenskogo/','Французский политик раскритиковал поведение Зеленского'),
	 ('https://lenta.ru/news/2022/12/17/povedeniye_zelenskogo/',10,1,'2022-12-17 21:41:00+08','https://lenta.ru/news/2022/12/17/povedeniye_zelenskogo/','Французский политик раскритиковал поведение Зеленского');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/sho_mos/',4,1,'2022-12-17 21:41:00+08','https://lenta.ru/news/2022/12/17/sho_mos/','Шольц высказался о готовности вновь поехать в Москву'),
	 ('https://lenta.ru/news/2022/12/17/sho_mos/',10,1,'2022-12-17 21:41:00+08','https://lenta.ru/news/2022/12/17/sho_mos/','Шольц высказался о готовности вновь поехать в Москву'),
	 ('https://lenta.ru/news/2022/12/17/otryad/',4,1,'2022-12-17 21:36:00+08','https://lenta.ru/news/2022/12/17/otryad/','В Белоруссии создадут отряды из запасников для борьбы с диверсантами'),
	 ('https://lenta.ru/news/2022/12/17/record/',5,1,'2022-12-17 21:35:00+08','https://lenta.ru/news/2022/12/17/record/','Иммунолог дал прогноз по заболеваемости гриппом в России'),
	 ('https://lenta.ru/news/2022/12/17/pojarsklad/',5,1,'2022-12-17 21:33:00+08','https://lenta.ru/news/2022/12/17/pojarsklad/','Крупный пожар на складе во Владивостоке попал на видео'),
	 ('https://lenta.ru/news/2022/12/17/sobakakip/',5,1,'2022-12-17 21:15:24+08','https://lenta.ru/news/2022/12/17/sobakakip/','Выгуливавший собаку россиянин упал с моста в кипяток и погиб'),
	 ('https://lenta.ru/news/2022/12/17/penizillin/',6,1,'2022-12-17 21:13:00+08','https://lenta.ru/news/2022/12/17/penizillin/','ВС РФ получили новую партию комплексов разведки «Пенициллин»'),
	 ('https://lenta.ru/news/2022/12/17/german_gas/',4,1,'2022-12-17 21:07:00+08','https://lenta.ru/news/2022/12/17/german_gas/','В Германии запустили первый плавучий терминал для приема СПГ'),
	 ('https://lenta.ru/news/2022/12/17/german_gas/',10,1,'2022-12-17 21:07:00+08','https://lenta.ru/news/2022/12/17/german_gas/','В Германии запустили первый плавучий терминал для приема СПГ'),
	 ('https://lenta.ru/news/2022/12/17/fireee/',5,1,'2022-12-17 21:05:00+08','https://lenta.ru/news/2022/12/17/fireee/','Во Владивостоке начался мощный пожар');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/telopered/',7,1,'2022-12-17 21:02:12+08','https://lenta.ru/news/2022/12/17/telopered/','Задержанного в СИЗО с телефонами в теле адвоката арестовали'),
	 ('https://lenta.ru/news/2022/12/17/nt9gt/',6,1,'2022-12-17 20:59:00+08','https://lenta.ru/news/2022/12/17/nt9gt/','ВВС США заказали разработку ударно-разведывательного гиперзвукового аппарата'),
	 ('https://lenta.ru/news/2022/12/17/penicillinpreimush/',6,1,'2022-12-17 20:59:00+08','https://lenta.ru/news/2022/12/17/penicillinpreimush/','Названо основное преимущество российского комплекса «Пенициллин»'),
	 ('https://lenta.ru/news/2022/12/17/domina/',8,1,'2022-12-17 20:58:00+08','https://lenta.ru/news/2022/12/17/domina/','Первая учительница Месси обратилась к футболисту перед финалом ЧМ-2022'),
	 ('https://lenta.ru/news/2022/12/17/monkey/',1,1,'2022-12-17 20:52:00+08','https://lenta.ru/news/2022/12/17/monkey/','В Швеции застрелили четырех сбежавших из зоопарка шимпанзе'),
	 ('https://lenta.ru/news/2022/12/17/vremdisl/',5,1,'2022-12-17 20:48:00+08','https://lenta.ru/news/2022/12/17/vremdisl/','Минобороны отчиталось об ударе по наемникам в районе Красного Лимана'),
	 ('https://lenta.ru/news/2022/12/17/ukr/',4,1,'2022-12-17 20:43:12+08','https://lenta.ru/news/2022/12/17/ukr/','На Украине сообщили о задержке движения более 40 поездов'),
	 ('https://lenta.ru/news/2022/12/17/divers/',5,1,'2022-12-17 20:40:00+08','https://lenta.ru/news/2022/12/17/divers/','В ДНР уничтожили две украинские диверсионные группы'),
	 ('https://lenta.ru/news/2022/12/17/lozhnyye_tseli/',5,1,'2022-12-17 20:34:00+08','https://lenta.ru/news/2022/12/17/lozhnyye_tseli/','Украинская ПВО израсходовала ресурсы из-за запущенных ВС России ложных целей'),
	 ('https://lenta.ru/news/2022/12/17/tekhnika_vsu/',5,1,'2022-12-17 20:27:00+08','https://lenta.ru/news/2022/12/17/tekhnika_vsu/','В Минобороны раскрыли количество уничтоженной украинской техники');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/dnrpoz/',5,1,'2022-12-17 20:23:00+08','https://lenta.ru/news/2022/12/17/dnrpoz/','Российские войска продолжили наступление на донецком направлении'),
	 ('https://lenta.ru/news/2022/12/17/kupyanskoye_napravleniye/',5,1,'2022-12-17 20:22:00+08','https://lenta.ru/news/2022/12/17/kupyanskoye_napravleniye/','Российские войска поразили подразделения ВСУ на купянском направлении'),
	 ('https://lenta.ru/news/2022/12/17/zaliman/',5,1,'2022-12-17 20:22:00+08','https://lenta.ru/news/2022/12/17/zaliman/','Российская ПВО сбила два украинских беспилотника в ЛНР'),
	 ('https://lenta.ru/news/2022/12/17/udar/',5,1,'2022-12-17 20:19:00+08','https://lenta.ru/news/2022/12/17/udar/','Минобороны России сообщило о массированном ударе по целям на Украине'),
	 ('https://lenta.ru/news/2022/12/17/orbanotdel/',4,1,'2022-12-17 19:58:00+08','https://lenta.ru/news/2022/12/17/orbanotdel/','Орбан рассказал о решении ЕС отделить российскую экономику от европейской'),
	 ('https://lenta.ru/news/2022/12/17/orbanotdel/',10,1,'2022-12-17 19:58:00+08','https://lenta.ru/news/2022/12/17/orbanotdel/','Орбан рассказал о решении ЕС отделить российскую экономику от европейской'),
	 ('https://lenta.ru/news/2022/12/17/ctctn7/',6,1,'2022-12-17 19:55:00+08','https://lenta.ru/news/2022/12/17/ctctn7/','«Роскосмос» допустил досрочный запуск нового «Союза» из-за утечки на МКС'),
	 ('https://lenta.ru/news/2022/12/17/ronn/',8,1,'2022-12-17 19:55:00+08','https://lenta.ru/news/2022/12/17/ronn/','Роналдиньо сделал прогноз на финал чемпионата мира по футболу в Катаре'),
	 ('https://lenta.ru/news/2022/12/17/voenk/',5,1,'2022-12-17 19:50:00+08','https://lenta.ru/news/2022/12/17/voenk/','Военком Подмосковья прокомментировал данные об изменении сроков срочной службы'),
	 ('https://lenta.ru/news/2022/12/17/trump_delo/',4,1,'2022-12-17 19:45:00+08','https://lenta.ru/news/2022/12/17/trump_delo/','Конгресс США попросит возбудить уголовное дело против Трампа');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/trump_delo/',10,1,'2022-12-17 19:45:00+08','https://lenta.ru/news/2022/12/17/trump_delo/','Конгресс США попросит возбудить уголовное дело против Трампа'),
	 ('https://lenta.ru/news/2022/12/17/purpleheart/',4,1,'2022-12-17 19:43:00+08','https://lenta.ru/news/2022/12/17/purpleheart/','Байден перепутал дату смерти своего отца'),
	 ('https://lenta.ru/news/2022/12/17/purpleheart/',10,1,'2022-12-17 19:43:00+08','https://lenta.ru/news/2022/12/17/purpleheart/','Байден перепутал дату смерти своего отца'),
	 ('https://lenta.ru/news/2022/12/17/beli/',5,1,'2022-12-17 19:39:00+08','https://lenta.ru/news/2022/12/17/beli/','В Госдуме высказались о последствиях войны с Россией для НАТО'),
	 ('https://lenta.ru/news/2022/12/17/dve_versii/',7,1,'2022-12-17 19:38:00+08','https://lenta.ru/news/2022/12/17/dve_versii/','СК назвал основные версии крушения вертолета Ми-8 в Бурятии'),
	 ('https://lenta.ru/news/2022/12/17/germoboron/',4,1,'2022-12-17 19:20:00+08','https://lenta.ru/news/2022/12/17/germoboron/','Шольц оценил возможности немецкой армии'),
	 ('https://lenta.ru/news/2022/12/17/germoboron/',10,1,'2022-12-17 19:20:00+08','https://lenta.ru/news/2022/12/17/germoboron/','Шольц оценил возможности немецкой армии'),
	 ('https://lenta.ru/news/2022/12/17/moovie/',3,1,'2022-12-17 19:12:30+08','https://lenta.ru/news/2022/12/17/moovie/','Джеймс Кэмерон объяснил невозможность спасти обоих главных героев «Титаника»'),
	 ('https://lenta.ru/news/2022/12/17/desham/',8,1,'2022-12-17 19:06:17+08','https://lenta.ru/news/2022/12/17/desham/','Тренер Дешам заявил о желании французов увидеть победу Месси на ЧМ-2022'),
	 ('https://lenta.ru/news/2022/12/17/electrdef/',4,1,'2022-12-17 19:04:00+08','https://lenta.ru/news/2022/12/17/electrdef/','«Укрэнерго» сообщила о значительном дефиците в энергосистеме Украины');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/pensionernbuk/',7,1,'2022-12-17 19:03:00+08','https://lenta.ru/news/2022/12/17/pensionernbuk/','Российскую пенсионерку арестовали за убийство жены внука'),
	 ('https://lenta.ru/news/2022/12/17/videopogon/',7,1,'2022-12-17 18:58:00+08','https://lenta.ru/news/2022/12/17/videopogon/','Пытавшийся уехать от шести экипажей российской полиции водитель попал на видео'),
	 ('https://lenta.ru/news/2022/12/17/mid_sanctions/',4,1,'2022-12-17 18:54:00+08','https://lenta.ru/news/2022/12/17/mid_sanctions/','МИД прокомментировал новые санкции против России'),
	 ('https://lenta.ru/news/2022/12/17/mid_sanctions/',10,1,'2022-12-17 18:54:00+08','https://lenta.ru/news/2022/12/17/mid_sanctions/','МИД прокомментировал новые санкции против России'),
	 ('https://lenta.ru/news/2022/12/17/estoschool/',4,1,'2022-12-17 18:53:00+08','https://lenta.ru/news/2022/12/17/estoschool/','В Эстонии утвердили план перехода с русского языка на эстонский в школах'),
	 ('https://lenta.ru/news/2022/12/17/zelensky_figaro/',4,1,'2022-12-17 18:48:00+08','https://lenta.ru/news/2022/12/17/zelensky_figaro/','Французы обрадовались отказу ФИФА показывать речь Зеленского перед финалом ЧМ'),
	 ('https://lenta.ru/news/2022/12/17/zelensky_figaro/',10,1,'2022-12-17 18:48:00+08','https://lenta.ru/news/2022/12/17/zelensky_figaro/','Французы обрадовались отказу ФИФА показывать речь Зеленского перед финалом ЧМ'),
	 ('https://lenta.ru/news/2022/12/17/tez_tour/',1,1,'2022-12-17 18:37:42+08','https://lenta.ru/news/2022/12/17/tez_tour/','Крупный туроператор вернет россиянам деньги за сорванный отдых в Египте'),
	 ('https://lenta.ru/news/2022/12/17/nc8wg/',6,1,'2022-12-17 18:33:00+08','https://lenta.ru/news/2022/12/17/nc8wg/','«Роскосмос» рассказал о температуре на «Союзе МС-22»'),
	 ('https://lenta.ru/news/2022/12/17/granatometsluchaino/',4,1,'2022-12-17 18:29:00+08','https://lenta.ru/news/2022/12/17/granatometsluchaino/','Главный комендант полиции Польши объяснил случайный выстрел из гранатомета');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/granatometsluchaino/',10,1,'2022-12-17 18:29:00+08','https://lenta.ru/news/2022/12/17/granatometsluchaino/','Главный комендант полиции Польши объяснил случайный выстрел из гранатомета'),
	 ('https://lenta.ru/news/2022/12/17/spyashchiye_drg/',5,1,'2022-12-17 18:26:00+08','https://lenta.ru/news/2022/12/17/spyashchiye_drg/','Командир спецназа «Троя» рассказал о «спящих» украинских ДРГ под Сватово'),
	 ('https://lenta.ru/news/2022/12/17/stavrjuravl/',7,1,'2022-12-17 18:22:00+08','https://lenta.ru/news/2022/12/17/stavrjuravl/','В российском регионе произошла массовая гибель журавлей'),
	 ('https://lenta.ru/news/2022/12/17/ismailov/',8,1,'2022-12-17 18:11:00+08','https://lenta.ru/news/2022/12/17/ismailov/','Исмаилов оценил поражение Александра Емельяненко от блогера'),
	 ('https://lenta.ru/news/2022/12/17/journaltwit/',2,1,'2022-12-17 18:09:00+08','https://lenta.ru/news/2022/12/17/journaltwit/','Маск заявил о восстановлении Twitter-аккаунтов заблокированных журналистов'),
	 ('https://lenta.ru/news/2022/12/17/krym/',5,1,'2022-12-17 18:07:00+08','https://lenta.ru/news/2022/12/17/krym/','В Крыму заявили о новом этапе информационной войны Киева'),
	 ('https://lenta.ru/news/2022/12/17/car/',4,1,'2022-12-17 18:03:00+08','https://lenta.ru/news/2022/12/17/car/','Стало известно о состоянии главы «Русского дома» в ЦАР после покушения'),
	 ('https://lenta.ru/news/2022/12/17/car/',10,1,'2022-12-17 18:03:00+08','https://lenta.ru/news/2022/12/17/car/','Стало известно о состоянии главы «Русского дома» в ЦАР после покушения'),
	 ('https://lenta.ru/news/2022/12/17/zhurova/',4,1,'2022-12-17 18:01:11+08','https://lenta.ru/news/2022/12/17/zhurova/','В России отреагировали на призывы некоторых стран к Зеленскому начать переговоры'),
	 ('https://lenta.ru/news/2022/12/17/domgaz/',5,1,'2022-12-17 17:56:00+08','https://lenta.ru/news/2022/12/17/domgaz/','Пострадавший от взрыва газа дом в Нижневартовске снесут');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/zernoten/',9,1,'2022-12-17 17:54:00+08','https://lenta.ru/news/2022/12/17/zernoten/','Главы российских регионов заявили о вывозе зерна иностранцами по теневой схеме'),
	 ('https://lenta.ru/news/2022/12/17/mirnjertv/',5,1,'2022-12-17 17:48:00+08','https://lenta.ru/news/2022/12/17/mirnjertv/','Три мирных жителя погибли при обстреле Счастья в ЛНР'),
	 ('https://lenta.ru/news/2022/12/17/zamglav/',5,1,'2022-12-17 17:45:00+08','https://lenta.ru/news/2022/12/17/zamglav/','Замглавы Херсонской области перейдет на работу в другой регион'),
	 ('https://lenta.ru/news/2022/12/17/german/',4,1,'2022-12-17 17:37:00+08','https://lenta.ru/news/2022/12/17/german/','Шольц призвал не дать «оборваться нити» переговоров с Россией'),
	 ('https://lenta.ru/news/2022/12/17/german/',10,1,'2022-12-17 17:37:00+08','https://lenta.ru/news/2022/12/17/german/','Шольц призвал не дать «оборваться нити» переговоров с Россией'),
	 ('https://lenta.ru/news/2022/12/17/chechnya/',5,1,'2022-12-17 17:32:00+08','https://lenta.ru/news/2022/12/17/chechnya/','В Чечне в 2023 году реализуют 26 проектов в сфере туризма'),
	 ('https://lenta.ru/news/2022/12/17/trevo/',4,1,'2022-12-17 17:32:00+08','https://lenta.ru/news/2022/12/17/trevo/','На всей территории Украины объявили воздушную тревогу'),
	 ('https://lenta.ru/news/2022/12/17/krym_vsu/',5,1,'2022-12-17 17:28:00+08','https://lenta.ru/news/2022/12/17/krym_vsu/','В Крыму оценили шансы ВСУ на прорыв к полуострову'),
	 ('https://lenta.ru/news/2022/12/17/kotdtp/',1,1,'2022-12-17 17:25:00+08','https://lenta.ru/news/2022/12/17/kotdtp/','В России уличный кот спровоцировал аварию с тремя пострадавшими'),
	 ('https://lenta.ru/news/2022/12/17/tur/',5,1,'2022-12-17 17:15:00+08','https://lenta.ru/news/2022/12/17/tur/','Для детей участников СВО организуют новогоднюю туристическую программу в Москве');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/17/taikor/',4,1,'2022-12-17 17:14:00+08','https://lenta.ru/news/2022/12/17/taikor/','Король и королева Таиланда заразились коронавирусом'),
	 ('https://lenta.ru/news/2022/12/17/taikor/',10,1,'2022-12-17 17:14:00+08','https://lenta.ru/news/2022/12/17/taikor/','Король и королева Таиланда заразились коронавирусом'),
	 ('https://lenta.ru/news/2022/12/17/mos_bpla/',5,1,'2022-12-17 17:12:00+08','https://lenta.ru/news/2022/12/17/mos_bpla/','Раскрыты детали защиты Москвы от украинских беспилотников'),
	 ('https://lenta.ru/news/2022/12/17/kosovo_nato/',4,1,'2022-12-17 17:04:21+08','https://lenta.ru/news/2022/12/17/kosovo_nato/','НАТО усилило патрулирование севера Косово'),
	 ('https://lenta.ru/news/2022/12/17/kosovo_nato/',10,1,'2022-12-17 17:04:21+08','https://lenta.ru/news/2022/12/17/kosovo_nato/','НАТО усилило патрулирование севера Косово'),
	 ('https://lenta.ru/news/2022/12/17/neymar/',8,1,'2022-12-17 16:57:00+08','https://lenta.ru/news/2022/12/17/neymar/','Неймар заплатил футболисту сборной Бразилии за просьбу свести тату с его лицом'),
	 ('https://lenta.ru/news/2022/12/17/kupol/',5,1,'2022-12-17 16:52:00+08','https://lenta.ru/news/2022/12/17/kupol/','На Запорожской АЭС начали строить защитный купол'),
	 ('https://lenta.ru/news/2022/12/17/shk7/',5,1,'2022-12-17 16:47:03+08','https://lenta.ru/news/2022/12/17/shk7/','Российский школьник запутался в гамаке и впал в кому'),
	 ('https://lenta.ru/news/2022/12/17/corona/',5,1,'2022-12-17 16:44:00+08','https://lenta.ru/news/2022/12/17/corona/','В России выявили 7531 новый случай коронавируса'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955824-aksenov-krim',10,2,'2022-12-18 16:25:10+08','https://www.vedomosti.ru/politics/news/2022/12/18/955824-aksenov-krim','Аксенов: Крым предложит Белоруссии свои порты в качестве южных морских ворот ЕАЭС');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/dobrovoltsy/',10,1,'2022-12-19 16:28:00+08','https://lenta.ru/news/2022/12/19/dobrovoltsy/','Армия Польши решила набрать добровольцев'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/18/955823-korablya-spasatelya',6,2,'2022-12-18 16:00:16+08','https://www.vedomosti.ru/technology/news/2022/12/18/955823-korablya-spasatelya','«РИА Новости»: ускоренная отправка корабля-спасателя «Союз» к МКС займет месяц'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955821-krimu-predupredili',10,2,'2022-12-18 15:29:53+08','https://www.vedomosti.ru/politics/news/2022/12/18/955821-krimu-predupredili','В Крыму предупредили Грецию о рисках в случае передачи Украине С-300'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/18/955820-vitse-premer-moldavii',9,2,'2022-12-18 14:59:23+08','https://www.vedomosti.ru/economics/news/2022/12/18/955820-vitse-premer-moldavii','Вице-премьер Молдавии заявил о достижении независимости от «Газпрома»'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955818-shoigu',10,2,'2022-12-18 14:20:57+08','https://www.vedomosti.ru/politics/news/2022/12/18/955818-shoigu','Шойгу проверил передовые позиции подразделений РФ в зоне спецоперации'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/17/955812-krima-spisok-vbrosami-telegram-kanalov',6,2,'2022-12-18 02:13:56+08','https://www.vedomosti.ru/technology/news/2022/12/17/955812-krima-spisok-vbrosami-telegram-kanalov','Власти Крыма составят список занимающихся вбросами Telegram-каналов'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/17/955808-zaharova-moldaviya-zachischaet',10,2,'2022-12-18 00:33:30+08','https://www.vedomosti.ru/politics/news/2022/12/17/955808-zaharova-moldaviya-zachischaet','Захарова: Молдавия зачищает информационное поле от альтернативных точек зрения'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/17/955807-mintsifri-massovih-ugonah-telegram',6,2,'2022-12-17 23:50:34+08','https://www.vedomosti.ru/technology/news/2022/12/17/955807-mintsifri-massovih-ugonah-telegram','Минцифры предупредило о массовых угонах аккаунтов в Telegram'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/17/955804-glava-spch',10,2,'2022-12-17 22:49:16+08','https://www.vedomosti.ru/politics/news/2022/12/17/955804-glava-spch','Глава СПЧ попросил Госдуму организовать слушания по законопроекту о биометрии'),
	 ('https://www.vedomosti.ru/society/news/2022/12/17/955803-turoperator',1,2,'2022-12-17 22:22:20+08','https://www.vedomosti.ru/society/news/2022/12/17/955803-turoperator','Туроператор заявил о возвращении застрявших в Египте россиян рейсами Red Wings');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/business/news/2022/12/17/955801-lukoile',9,2,'2022-12-17 21:57:48+08','https://www.vedomosti.ru/business/news/2022/12/17/955801-lukoile','В «Лукойле» заявили, что санкции ЕС могут ограничить работу НПЗ в Болгарии'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/17/955800-roskosmos-venesuele-glonass-2023',6,2,'2022-12-17 21:50:58+08','https://www.vedomosti.ru/technology/news/2022/12/17/955800-roskosmos-venesuele-glonass-2023','«Роскосмос» построит в Венесуэле станцию ГЛОНАСС в 2023 году'),
	 ('https://www.vedomosti.ru/society/news/2022/12/17/955798-estonii',1,2,'2022-12-17 21:25:19+08','https://www.vedomosti.ru/society/news/2022/12/17/955798-estonii','В Эстонии утвердили план перевода школ и детсадов на эстоноязычное образование'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/17/955795-minoboroni',10,2,'2022-12-17 20:42:55+08','https://www.vedomosti.ru/politics/news/2022/12/17/955795-minoboroni','Минобороны объяснило ущерб гражданской инфраструктуре Украины работой ПВО'),
	 ('https://www.vedomosti.ru/society/news/2022/12/17/955794-minoboroni-izmenenie-srokov-prizivu',1,2,'2022-12-17 20:32:46+08','https://www.vedomosti.ru/society/news/2022/12/17/955794-minoboroni-izmenenie-srokov-prizivu','Минобороны РФ: изменение сроков службы по призыву не предлагается'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/17/955793-obostreniya-sotsialno-ekonomicheskih',9,2,'2022-12-17 20:08:50+08','https://www.vedomosti.ru/politics/news/2022/12/17/955793-obostreniya-sotsialno-ekonomicheskih','Захарова ожидает обострения социально-экономических проблем в ЕС на фоне санкций'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/17/955790-sholts-sohranit-peregovorov-rossiei',10,2,'2022-12-17 19:41:49+08','https://www.vedomosti.ru/politics/news/2022/12/17/955790-sholts-sohranit-peregovorov-rossiei','Шольц призвал сохранить «нить переговоров» с Россией вопреки разногласиям'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/17/955788-otmenit-sanktsii',9,2,'2022-12-17 19:06:43+08','https://www.vedomosti.ru/economics/news/2022/12/17/955788-otmenit-sanktsii','В МИДе потребовали отменить санкции ЕС против экспорта сельхозпродукции из РФ'),
	 ('https://www.vedomosti.ru/society/news/2022/12/17/955786-rospotrebnadzore-rasskazali',1,2,'2022-12-17 18:05:51+08','https://www.vedomosti.ru/society/news/2022/12/17/955786-rospotrebnadzore-rasskazali','В Роспотребнадзоре рассказали о непростой ситуации по менингиту среди мигрантов'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/17/955784-predlozhili-ogranichit-uchastie',9,2,'2022-12-17 17:37:42+08','https://www.vedomosti.ru/economics/news/2022/12/17/955784-predlozhili-ogranichit-uchastie','Главы трех регионов предложили Путину ограничить участие иностранцев в экспорте зерна');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/politics/news/2022/12/17/955783-rogov',10,2,'2022-12-17 16:57:28+08','https://www.vedomosti.ru/politics/news/2022/12/17/955783-rogov','Рогов: на Запорожской АЭС начался монтаж защитного купола'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/17/955781-pravitelstvo',9,2,'2022-12-17 16:31:00+08','https://www.vedomosti.ru/economics/news/2022/12/17/955781-pravitelstvo','Правительство направит на поддержку рынка труда 12,8 млрд рублей'),
	 ('https://www.vedomosti.ru/media/news/2022/12/17/955780-moldavii',2,2,'2022-12-17 16:03:27+08','https://www.vedomosti.ru/media/news/2022/12/17/955780-moldavii','В Молдавии в целях защиты от дезинформации приостановили вещание шести СМИ'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/17/955778-postpredstve',10,2,'2022-12-17 15:27:57+08','https://www.vedomosti.ru/politics/news/2022/12/17/955778-postpredstve','В постпредстве при Евросоюзе назвали нелегитимными новые санкции против РФ'),
	 ('https://lenta.ru/news/2022/12/19/kommunalkaa/',5,1,'2022-12-19 19:30:00+08','https://lenta.ru/news/2022/12/19/kommunalkaa/','Жители московской коммуналки 15 лет жили с мертвым соседом'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/17/955777-muftiyat',10,2,'2022-12-17 14:50:29+08','https://www.vedomosti.ru/politics/news/2022/12/17/955777-muftiyat','Муфтият Крыма заявил о захвате мечети на полуострове «исламскими сектантами»'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/17/955775-putin',10,2,'2022-12-17 14:18:28+08','https://www.vedomosti.ru/politics/news/2022/12/17/955775-putin','Путин ознакомился с работой штаба родов войск, задействованных в СВО'),
	 ('https://www.vedomosti.ru/business/news/2022/12/16/955771-ifly-otmenit-egipet',9,2,'2022-12-17 03:43:13+08','https://www.vedomosti.ru/business/news/2022/12/16/955771-ifly-otmenit-egipet','Авиакомпания iFly отменит рейсы в Египет минимум до 19 декабря'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955770-peskov-nazval-polnoi-chushyu',10,2,'2022-12-17 03:04:54+08','https://www.vedomosti.ru/politics/news/2022/12/16/955770-peskov-nazval-polnoi-chushyu','Песков назвал «полной чушью» утверждения о поручении ликвидировать Зеленского'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955764-dzholi-pokinet-oon',1,2,'2022-12-17 03:01:25+08','https://www.vedomosti.ru/society/news/2022/12/16/955764-dzholi-pokinet-oon','Анджелина Джоли покинула пост специального посланника УВКБ ООН');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955768-minyust-vnes-wonderzine',1,2,'2022-12-17 02:45:37+08','https://www.vedomosti.ru/society/news/2022/12/16/955768-minyust-vnes-wonderzine','Минюст внес главного редактора Wonderzine в реестр иноагентов'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955759-na-meste-zapiska',10,2,'2022-12-17 02:03:38+08','https://www.vedomosti.ru/politics/news/2022/12/16/955759-na-meste-zapiska','На месте покушения на главу «Русского дома» в ЦАР обнаружена записка с угрозой'),
	 ('https://www.vedomosti.ru/media/news/2022/12/16/955758-tv3-razorvet-s-dozhdem',2,2,'2022-12-17 01:38:41+08','https://www.vedomosti.ru/media/news/2022/12/16/955758-tv3-razorvet-s-dozhdem','Латвийский телеканал TV3 разорвет договор аренды помещения с «Дождем»'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955756-v-vengrii-vistupayut',10,2,'2022-12-17 01:17:10+08','https://www.vedomosti.ru/politics/news/2022/12/16/955756-v-vengrii-vistupayut','Bloomberg: в Венгрии выступают за скорейшее вступление Украины в Евросоюз'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955753-horvatiya-reshila-ne-trenirovat',10,2,'2022-12-17 00:45:42+08','https://www.vedomosti.ru/politics/news/2022/12/16/955753-horvatiya-reshila-ne-trenirovat','Хорватия решила не тренировать украинских солдат в рамках миссии ЕС'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955749-v-kaliningradskoi-oblasti-ucheniya',10,2,'2022-12-17 00:22:29+08','https://www.vedomosti.ru/politics/news/2022/12/16/955749-v-kaliningradskoi-oblasti-ucheniya','В Калининградской области начались учения с участием более 1500 военных'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955748-sud-arestoval-nachalnika-uchastka',1,2,'2022-12-17 00:06:47+08','https://www.vedomosti.ru/society/news/2022/12/16/955748-sud-arestoval-nachalnika-uchastka','Суд арестовал начальника участка фирмы, проводившей работы в OBI в Химках'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/16/955746-moldovagaz-zayavil-o-pogashenii',9,2,'2022-12-16 23:52:41+08','https://www.vedomosti.ru/economics/news/2022/12/16/955746-moldovagaz-zayavil-o-pogashenii','«Молдовагаз» заявил о погашении задолженности перед «Газпромом» за ноябрь и декабрь'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955743-fifa-otkazalas-translirovat-zelenskogo',1,2,'2022-12-16 23:43:01+08','https://www.vedomosti.ru/society/news/2022/12/16/955743-fifa-otkazalas-translirovat-zelenskogo','CNN: ФИФА отказалась транслировать видеообращение Зеленского перед финалом ЧМ'),
	 ('https://www.vedomosti.ru/business/news/2022/12/16/955741-es-prigrozil-masku-sanktsiyami',9,2,'2022-12-16 23:39:41+08','https://www.vedomosti.ru/business/news/2022/12/16/955741-es-prigrozil-masku-sanktsiyami','ЕС пригрозил Маску санкциями за блокировку аккаунтов американских журналистов');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955742-sud-otpravil-pod-domashnii-arest',1,2,'2022-12-16 23:29:56+08','https://www.vedomosti.ru/society/news/2022/12/16/955742-sud-otpravil-pod-domashnii-arest','Суд отправил под домашний арест начальника управления профподготовки МВД'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955738-uchastniki-svo-smogut-otpravlyat',1,2,'2022-12-16 23:19:53+08','https://www.vedomosti.ru/society/news/2022/12/16/955738-uchastniki-svo-smogut-otpravlyat','Участники СВО смогут бесплатно отправлять письма домой'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955737-shveitsariya-prisoedinilas-potolku',10,2,'2022-12-16 23:06:28+08','https://www.vedomosti.ru/politics/news/2022/12/16/955737-shveitsariya-prisoedinilas-potolku','Швейцария присоединилась к потолку цен на российскую нефть'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/16/955734-mts-zaregistriroval-tovarnii',6,2,'2022-12-16 22:59:08+08','https://www.vedomosti.ru/technology/news/2022/12/16/955734-mts-zaregistriroval-tovarnii','МТС зарегистрировала товарный знак «Мне только спросить»'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955732-rossiyane-stali-menshe-darit',1,2,'2022-12-16 22:51:12+08','https://www.vedomosti.ru/society/news/2022/12/16/955732-rossiyane-stali-menshe-darit','Россияне в этом году стали меньше дарить подарки'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955710-v-mide-osudili',10,2,'2022-12-16 22:47:26+08','https://www.vedomosti.ru/politics/news/2022/12/16/955710-v-mide-osudili','В МИДе решительно осудили покушение на главу «Русского дома» в ЦАР'),
	 ('https://www.vedomosti.ru/business/news/2022/12/16/955730-ikea-sohranit-rabochie-mesta',9,2,'2022-12-16 22:38:07+08','https://www.vedomosti.ru/business/news/2022/12/16/955730-ikea-sohranit-rabochie-mesta','IKEA пообещала сохранить рабочие места сотрудникам фабрик в России на год'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955727-figuranti-poluchili-do-13-let',1,2,'2022-12-16 22:31:45+08','https://www.vedomosti.ru/society/news/2022/12/16/955727-figuranti-poluchili-do-13-let','Фигуранты дела о хищении 660 млн рублей из бюджета Москвы получили до 13 лет колонии'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/16/955721-roskosmos-oproverg-informatsiyu',6,2,'2022-12-16 22:14:51+08','https://www.vedomosti.ru/technology/news/2022/12/16/955721-roskosmos-oproverg-informatsiyu','«Роскосмос» опроверг информацию о повышении температуры в «Союзе МС-22» до +50'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955709-glava-fonda-prokommentiroval-isklyuchenie-hamatovoi',1,2,'2022-12-16 22:10:40+08','https://www.vedomosti.ru/society/news/2022/12/16/955709-glava-fonda-prokommentiroval-isklyuchenie-hamatovoi','Глава фонда «Круг добра» прокомментировал исключение Хаматовой и Раппопорт из попечительского совета');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/business/news/2022/12/16/955720-ifly-vozobnovit-otpravku',9,2,'2022-12-16 22:06:54+08','https://www.vedomosti.ru/business/news/2022/12/16/955720-ifly-vozobnovit-otpravku','Авиакомпания iFly возобновит в пятницу отправку туристов в Египет'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/16/955719-nabiullina-sprognozirovala-spad-vvp',9,2,'2022-12-16 22:00:10+08','https://www.vedomosti.ru/economics/news/2022/12/16/955719-nabiullina-sprognozirovala-spad-vvp','Набиуллина спрогнозировала спад ВВП по итогам года вблизи 3%'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955713-v-gosdumu-vnesli-proekt',1,2,'2022-12-16 21:46:43+08','https://www.vedomosti.ru/society/news/2022/12/16/955713-v-gosdumu-vnesli-proekt','В Госдуму внесли проект об освобождении имеющих ученую степень от мобилизации'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/16/955711-turtsiya-namerena-stat-tsentrom',9,2,'2022-12-16 21:28:28+08','https://www.vedomosti.ru/economics/news/2022/12/16/955711-turtsiya-namerena-stat-tsentrom','Эрдоган: Турция намерена стать глобальным центром ценообразования на газ'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955703-vengriya-zamorozila-aktivi',10,2,'2022-12-16 21:09:47+08','https://www.vedomosti.ru/politics/news/2022/12/16/955703-vengriya-zamorozila-aktivi','СМИ: Венгрия заморозила российские активы почти на 900 млн евро'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955702-sotsialnie-viplati-proindeksiruyut',1,2,'2022-12-16 21:04:07+08','https://www.vedomosti.ru/society/news/2022/12/16/955702-sotsialnie-viplati-proindeksiruyut','Социальные выплаты в Москве проиндексируют на 10% с начала года'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/16/955698-nabiullina-o-zamedlenii-godovoi-inflyatsii',9,2,'2022-12-16 20:40:53+08','https://www.vedomosti.ru/economics/news/2022/12/16/955698-nabiullina-o-zamedlenii-godovoi-inflyatsii','Набиуллина сообщила о замедлении годовой инфляции в ближайшие месяцы'),
	 ('https://www.vedomosti.ru/business/news/2022/12/16/955695-tiktok-sokratit-shtat-sotrudnikov',9,2,'2022-12-16 20:19:45+08','https://www.vedomosti.ru/business/news/2022/12/16/955695-tiktok-sokratit-shtat-sotrudnikov','TikTok сократит штат сотрудников в России'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955689-paromnoe-soobschenie-mogut',1,2,'2022-12-16 20:04:55+08','https://www.vedomosti.ru/society/news/2022/12/16/955689-paromnoe-soobschenie-mogut','Паромное сообщение между Сочи и Турцией могут запустить в 2023 году'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955693-v-moskve-izmenyat-dvizhenie-po-koltsevoi-linii-metro',1,2,'2022-12-16 20:01:56+08','https://www.vedomosti.ru/society/news/2022/12/16/955693-v-moskve-izmenyat-dvizhenie-po-koltsevoi-linii-metro','В Москве изменят движение по кольцевой линии метро со 2 по 7 января');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955677-putin-obsudil-s-indiiskim',10,2,'2022-12-16 19:52:18+08','https://www.vedomosti.ru/politics/news/2022/12/16/955677-putin-obsudil-s-indiiskim','Путин обсудил с индийским премьером ситуацию на Украине'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955683-gospitalizirovali-glavu-russkogo-doma',1,2,'2022-12-16 19:49:58+08','https://www.vedomosti.ru/society/news/2022/12/16/955683-gospitalizirovali-glavu-russkogo-doma','В ЦАР после покушения госпитализировали главу «Русского дома»'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955686-es-vklyuchil-spisok',10,2,'2022-12-16 19:48:29+08','https://www.vedomosti.ru/politics/news/2022/12/16/955686-es-vklyuchil-spisok','ЕС включил в санкционный список 168 российских компаний'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955675-v-otele-berlina-lopnul',1,2,'2022-12-16 19:38:58+08','https://www.vedomosti.ru/society/news/2022/12/16/955675-v-otele-berlina-lopnul','В отеле Берлина лопнул самый большой в мире аквариум'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/16/955671-bezrabotitsa-minimum',9,2,'2022-12-16 19:30:42+08','https://www.vedomosti.ru/economics/news/2022/12/16/955671-bezrabotitsa-minimum','ЦБ: безработица в России обновила исторический минимум'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955672-uchenie-sankt-peterburga-vaktsini',1,2,'2022-12-16 19:25:58+08','https://www.vedomosti.ru/society/news/2022/12/16/955672-uchenie-sankt-peterburga-vaktsini','Ученые из Санкт-Петербурга сообщили о разработке вакцины от гриппа в виде капсулы'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955656-ispolzovannie-dlya-atak-ssha',10,2,'2022-12-16 19:14:01+08','https://www.vedomosti.ru/politics/news/2022/12/16/955656-ispolzovannie-dlya-atak-ssha','«РИА Новости»: использованные для атак на Крым беспилотники изготовлены в США'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/16/955666-tsb-defitsita-rabochei-sili',9,2,'2022-12-16 18:57:15+08','https://www.vedomosti.ru/economics/news/2022/12/16/955666-tsb-defitsita-rabochei-sili','ЦБ заявил об усилении дефицита рабочей силы на фоне частичной мобилизации'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955661-serbiya-peredala-missii-nato-zapros-na-vvedenie-kontingenta',10,2,'2022-12-16 18:52:07+08','https://www.vedomosti.ru/politics/news/2022/12/16/955661-serbiya-peredala-missii-nato-zapros-na-vvedenie-kontingenta','Сербия передала миссии НАТО запрос на введение контингента армии и полиции в Косово'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955665-hinshtein-mobilizovannih-osvobodyat-ot-nakazaniya',1,2,'2022-12-16 18:50:52+08','https://www.vedomosti.ru/society/news/2022/12/16/955665-hinshtein-mobilizovannih-osvobodyat-ot-nakazaniya','Хинштейн предложил смягчить требования для мобилизованных по лицензии на оружие');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955657-minoboroni-kontratak-vsu',10,2,'2022-12-16 18:34:37+08','https://www.vedomosti.ru/politics/news/2022/12/16/955657-minoboroni-kontratak-vsu','Минобороны сообщило об отражении трех контратак ВСУ в ДНР и ЛНР'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955648-o-telefonnom-razgovore-putina-s-premerom-indii',10,2,'2022-12-16 18:25:14+08','https://www.vedomosti.ru/politics/news/2022/12/16/955648-o-telefonnom-razgovore-putina-s-premerom-indii','В Кремле сообщили о телефонном разговоре Путина с премьером Индии'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955647-v-kremle-s-interesom-oznakomyatsya-s-ideyami-kissindzhera',10,2,'2022-12-16 18:13:39+08','https://www.vedomosti.ru/politics/news/2022/12/16/955647-v-kremle-s-interesom-oznakomyatsya-s-ideyami-kissindzhera','В Кремле с интересом ознакомятся с идеями Киссинджера об урегулировании на Украине'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955645-peregovori-putina-lukashenko',10,2,'2022-12-16 18:13:20+08','https://www.vedomosti.ru/politics/news/2022/12/16/955645-peregovori-putina-lukashenko','В Кремле прокомментировали предстоящие переговоры Путина и Лукашенко'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955644-putin-provedet-zasedanie-gossoveta-v-ochnom-formate',10,2,'2022-12-16 18:08:43+08','https://www.vedomosti.ru/politics/news/2022/12/16/955644-putin-provedet-zasedanie-gossoveta-v-ochnom-formate','Путин проведет заседание Госсовета в очном формате 22 декабря'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955634-lukashenko-gaza',10,2,'2022-12-16 17:53:09+08','https://www.vedomosti.ru/politics/news/2022/12/16/955634-lukashenko-gaza','Лукашенко сообщил о срыве сроков реализации единого рынка газа с Россией'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955632-peskov-zayavil-o-skorom-otvete-rossii-na-potolok',10,2,'2022-12-16 17:51:26+08','https://www.vedomosti.ru/politics/news/2022/12/16/955632-peskov-zayavil-o-skorom-otvete-rossii-na-potolok','Песков заявил о скором ответе России на потолок цен на нефть'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955630-v-buryatii-nazvali-predvaritelnie-prichini-krusheniya-mi-8',1,2,'2022-12-16 17:50:13+08','https://www.vedomosti.ru/society/news/2022/12/16/955630-v-buryatii-nazvali-predvaritelnie-prichini-krusheniya-mi-8','В Бурятии назвали предварительные причины крушения частного вертолета Ми-8'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955624-pasechnik-soobschil-o-vosmi-pogibshih',1,2,'2022-12-16 17:41:24+08','https://www.vedomosti.ru/society/news/2022/12/16/955624-pasechnik-soobschil-o-vosmi-pogibshih','Пасечник сообщил о восьми погибших в результате обстрела ЛНР'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955621-v-kremle-podtverdili-poezdku-putina-v-belorussiyu',10,2,'2022-12-16 17:17:00+08','https://www.vedomosti.ru/politics/news/2022/12/16/955621-v-kremle-podtverdili-poezdku-putina-v-belorussiyu','В Кремле подтвердили поездку Путина в Белоруссию');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955612-v-gosdume-ne-podderzhali-ideyu-ob-ugolovnom-nakazanii-za-lgbt-propagandu',1,2,'2022-12-16 17:15:22+08','https://www.vedomosti.ru/society/news/2022/12/16/955612-v-gosdume-ne-podderzhali-ideyu-ob-ugolovnom-nakazanii-za-lgbt-propagandu','В Госдуме не поддержали идею об уголовном наказании за ЛГБТ-пропаганду'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955617-putin-sovbezom',10,2,'2022-12-16 17:11:30+08','https://www.vedomosti.ru/politics/news/2022/12/16/955617-putin-sovbezom','Путин обсудил с Совбезом вопросы безопасности'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955616-roskomnadzor-soobschil-ob-utechke-bolee-600-mln',1,2,'2022-12-16 17:09:54+08','https://www.vedomosti.ru/society/news/2022/12/16/955616-roskomnadzor-soobschil-ob-utechke-bolee-600-mln','Роскомнадзор сообщил об утечке более 600 млн записей о россиянах с начала спецоперации'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955614-krimskomu-mostu',1,2,'2022-12-16 16:56:45+08','https://www.vedomosti.ru/society/news/2022/12/16/955614-krimskomu-mostu','Движение по Крымскому мосту будет ограничено 19 декабря'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/16/955611-v-pravitelstve-utverdili-dorozhnie-karti-po-esche',6,2,'2022-12-16 16:53:41+08','https://www.vedomosti.ru/technology/news/2022/12/16/955611-v-pravitelstve-utverdili-dorozhnie-karti-po-esche','В правительстве утвердили дорожные карты по еще двум высокотехнологичным направлениям'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955609-v-belgorodskoi-oblasti-soobschili-o-popadanii-snaryada',1,2,'2022-12-16 16:39:46+08','https://www.vedomosti.ru/society/news/2022/12/16/955609-v-belgorodskoi-oblasti-soobschili-o-popadanii-snaryada','В Белгородской области сообщили о попадании снаряда в подвал школы'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955607-medvedev-voennie-tseli-nato',10,2,'2022-12-16 16:38:44+08','https://www.vedomosti.ru/politics/news/2022/12/16/955607-medvedev-voennie-tseli-nato','Медведев обозначил законные военные цели'),
	 ('https://www.vedomosti.ru/finance/news/2022/12/16/955604-rosbank-priostanovil-operatsii-v-dollarah-i-evro',9,2,'2022-12-16 16:30:19+08','https://www.vedomosti.ru/finance/news/2022/12/16/955604-rosbank-priostanovil-operatsii-v-dollarah-i-evro','Росбанк приостановил операции в долларах и евро из-за санкций США'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955606-smi-tri-cheloveka-pogibli-pri-krushenii-vertoleta',1,2,'2022-12-16 16:26:45+08','https://www.vedomosti.ru/society/news/2022/12/16/955606-smi-tri-cheloveka-pogibli-pri-krushenii-vertoleta','СМИ: в Бурятии разбился частный вертолет Ми-8'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/16/955602-bloomberg-serbiya-hochet-snizit-zavisimost',9,2,'2022-12-16 16:20:30+08','https://www.vedomosti.ru/economics/news/2022/12/16/955602-bloomberg-serbiya-hochet-snizit-zavisimost','Bloomberg: Сербия хочет снизить зависимость от газа из России');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/business/news/2022/12/16/955603-o-planah-henkel-obosobit-rossiiskii-biznes',9,2,'2022-12-16 16:16:26+08','https://www.vedomosti.ru/business/news/2022/12/16/955603-o-planah-henkel-obosobit-rossiiskii-biznes','«Коммерсантъ» сообщил о планах Henkel обособить российский бизнес'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955601-vlasti-ukraini-vzrivah',10,2,'2022-12-16 16:05:46+08','https://www.vedomosti.ru/politics/news/2022/12/16/955601-vlasti-ukraini-vzrivah','Власти нескольких областей Украины сообщили о взрывах'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955589-ria-novosti-v-berdyanske-zaderzhali-zhitelei-za-diversiyu',1,2,'2022-12-16 16:02:15+08','https://www.vedomosti.ru/society/news/2022/12/16/955589-ria-novosti-v-berdyanske-zaderzhali-zhitelei-za-diversiyu','«РИА Новости»: в Бердянске задержали диверсантов на железной дороге'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955591-dolya-rossiyan-s-trevozhnim-i-spokoinim-nastroeniem',1,2,'2022-12-16 15:34:29+08','https://www.vedomosti.ru/society/news/2022/12/16/955591-dolya-rossiyan-s-trevozhnim-i-spokoinim-nastroeniem','ФОМ: доля россиян с тревожным и спокойным настроением сравнялась'),
	 ('https://www.vedomosti.ru/society/news/2022/12/16/955588-vosem-chelovek-pogibli-v-dtp',1,2,'2022-12-16 15:33:54+08','https://www.vedomosti.ru/society/news/2022/12/16/955588-vosem-chelovek-pogibli-v-dtp','Восемь человек погибли в ДТП с вахтовиками в Хабаровском крае'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/16/955585-glava-akra-ekonomiki',9,2,'2022-12-16 15:21:12+08','https://www.vedomosti.ru/economics/news/2022/12/16/955585-glava-akra-ekonomiki','Глава АКРА назвал сроки возвращения российской экономики к показателям 2019 года'),
	 ('https://www.vedomosti.ru/business/news/2022/12/16/955581-avtodileri-soobschili-chto-novih-inomarok-v-rossii-ostalos-na',9,2,'2022-12-16 15:11:27+08','https://www.vedomosti.ru/business/news/2022/12/16/955581-avtodileri-soobschili-chto-novih-inomarok-v-rossii-ostalos-na','Автодилеры сообщили, что новых иномарок в России осталось на месяц продаж'),
	 ('https://www.vedomosti.ru/business/news/2022/12/16/955580-postavki-noutbukov',9,2,'2022-12-16 14:54:29+08','https://www.vedomosti.ru/business/news/2022/12/16/955580-postavki-noutbukov','В России сократились поставки ноутбуков на 65%'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955578-putin-i-lukashenko-vstretyatsya',10,2,'2022-12-16 14:38:33+08','https://www.vedomosti.ru/politics/news/2022/12/16/955578-putin-i-lukashenko-vstretyatsya','Путин и Лукашенко встретятся в Минске 19 декабря'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955577-euobserver-es-soglasoval-oslablenie-sanktsii',10,2,'2022-12-16 14:29:03+08','https://www.vedomosti.ru/politics/news/2022/12/16/955577-euobserver-es-soglasoval-oslablenie-sanktsii','EUobserver: ЕС согласовал ослабление санкций для нескольких предпринимателей из России');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955576-rossiya-rabotaet-nad-vvedeniem-bezvizovogo-rezhima',10,2,'2022-12-16 14:27:06+08','https://www.vedomosti.ru/politics/news/2022/12/16/955576-rossiya-rabotaet-nad-vvedeniem-bezvizovogo-rezhima','Россия работает над введением безвизового режима со странами Персидского залива'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955575-posolstvo-sanktsii-ssha',10,2,'2022-12-16 14:23:03+08','https://www.vedomosti.ru/politics/news/2022/12/16/955575-posolstvo-sanktsii-ssha','Посольство назвало новые санкции США против РФ «бессильной злобой»'),
	 ('https://www.vedomosti.ru/business/news/2022/12/16/955572-uznal-o-planah-apple-otkazatsya-ot-ofisa',9,2,'2022-12-16 14:14:22+08','https://www.vedomosti.ru/business/news/2022/12/16/955572-uznal-o-planah-apple-otkazatsya-ot-ofisa','РБК узнал о планах Apple отказаться от офиса рядом с Кремлем'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955571-zaharova-ssha-unichtozhili-bi-rossiyu',10,2,'2022-12-16 13:44:38+08','https://www.vedomosti.ru/politics/news/2022/12/16/955571-zaharova-ssha-unichtozhili-bi-rossiyu','Захарова: США уничтожили бы Россию при наличии такого способа'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/16/955569-rosstat-peresmotrel-traektoriyu-spada-vvp',9,2,'2022-12-16 13:28:05+08','https://www.vedomosti.ru/economics/news/2022/12/16/955569-rosstat-peresmotrel-traektoriyu-spada-vvp','РБК: Росстат пересмотрел траекторию спада ВВП после сезонного сглаживания'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955568-vuchich-serbiya-vvedet-sanktsii-protiv-rossii-lish-pri',10,2,'2022-12-16 12:49:11+08','https://www.vedomosti.ru/politics/news/2022/12/16/955568-vuchich-serbiya-vvedet-sanktsii-protiv-rossii-lish-pri','Вучич: Сербия введет санкции против России лишь при экзистенциальных угрозах'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/16/955567-es-soglasoval-devyatii-paket-sanktsii',10,2,'2022-12-16 12:25:08+08','https://www.vedomosti.ru/politics/news/2022/12/16/955567-es-soglasoval-devyatii-paket-sanktsii','ЕС согласовал девятый пакет санкций против России'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955553-v-kabmin-postupil-zakonoproekt',1,2,'2022-12-16 03:51:57+08','https://www.vedomosti.ru/society/news/2022/12/15/955553-v-kabmin-postupil-zakonoproekt','В кабмин поступил законопроект об ответственности за кражу персональных данных'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955544-es-sanktsii',10,2,'2022-12-16 03:29:23+08','https://www.vedomosti.ru/politics/news/2022/12/15/955544-es-sanktsii','ЕС может отложить принятие новых антироссийских санкций из-за позиции Польши'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955542-bosniya-gertsegovina',10,2,'2022-12-16 03:02:53+08','https://www.vedomosti.ru/politics/news/2022/12/15/955542-bosniya-gertsegovina','Боснии и Герцеговине предоставили статус кандидата на вступление в ЕС');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955539-baiden-g20',10,2,'2022-12-16 02:35:28+08','https://www.vedomosti.ru/politics/news/2022/12/15/955539-baiden-g20','Байден предложил Африканскому союзу присоединиться к G20'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955538-sammit-ne-soglasoval',10,2,'2022-12-16 02:14:20+08','https://www.vedomosti.ru/politics/news/2022/12/15/955538-sammit-ne-soglasoval','Саммит ЕС не согласовал потолок цен на газ'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955534-ssha-ne-namereni-blokirovat',10,2,'2022-12-16 01:47:31+08','https://www.vedomosti.ru/politics/news/2022/12/15/955534-ssha-ne-namereni-blokirovat','Госдеп: США не намерены блокировать всю финансовую систему России'),
	 ('https://www.vedomosti.ru/business/news/2022/12/15/955533-rosaviatsiya-rekomendovala-ifly-perevezti',9,2,'2022-12-16 01:26:42+08','https://www.vedomosti.ru/business/news/2022/12/15/955533-rosaviatsiya-rekomendovala-ifly-perevezti','Росавиация рекомендовала iFly перевезти пассажиров в Египет рейсами других компаний'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955531-vtb-prokommentiroval-sanktsii',10,2,'2022-12-16 00:56:26+08','https://www.vedomosti.ru/politics/news/2022/12/15/955531-vtb-prokommentiroval-sanktsii','ВТБ прокомментировал санкции США в отношении своих дочерних структур'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955529-golikova-soobschila-o-snizhenii-smertnosti',1,2,'2022-12-16 00:38:17+08','https://www.vedomosti.ru/society/news/2022/12/15/955529-golikova-soobschila-o-snizhenii-smertnosti','Голикова сообщила о снижении смертности в России на 19%'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955522-genshtab-ukraini-protiv',10,2,'2022-12-15 23:56:10+08','https://www.vedomosti.ru/politics/news/2022/12/15/955522-genshtab-ukraini-protiv','Генштаб Украины выступил против перемирия на Новый год'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955518-v-shtab-kvartire-vzorvalsya',10,2,'2022-12-15 23:51:50+08','https://www.vedomosti.ru/politics/news/2022/12/15/955518-v-shtab-kvartire-vzorvalsya','В штаб-квартире польской полиции взорвался подарок с Украины'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955517-pushilin-prazdnichnih-dnr',1,2,'2022-12-15 23:42:24+08','https://www.vedomosti.ru/society/news/2022/12/15/955517-pushilin-prazdnichnih-dnr','Пушилин утвердил четыре новых нерабочих праздничных дня в ДНР'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955519-ssha-vveli-sanktsii',10,2,'2022-12-15 23:32:40+08','https://www.vedomosti.ru/politics/news/2022/12/15/955519-ssha-vveli-sanktsii','США ввели санкции против Потанина и Белоусова');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955512-gubernator-kurskoi-ob-obstrele',1,2,'2022-12-15 23:24:17+08','https://www.vedomosti.ru/society/news/2022/12/15/955512-gubernator-kurskoi-ob-obstrele','Губернатор Курской области сообщил об обстреле хутора Кучеров'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955515-putin-isklyuchil-hamatovu',1,2,'2022-12-15 23:14:54+08','https://www.vedomosti.ru/society/news/2022/12/15/955515-putin-isklyuchil-hamatovu','Путин исключил Хаматову из попечительского совета фонда «Круг добра»'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/15/955509-obshivka-soyuza-mogla',6,2,'2022-12-15 23:04:07+08','https://www.vedomosti.ru/technology/news/2022/12/15/955509-obshivka-soyuza-mogla','«Роскосмос»: обшивка «Союза МС-22» могла быть повреждена из-за микрометеорита'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/15/955511-hartiyu-etiki',6,2,'2022-12-15 22:59:23+08','https://www.vedomosti.ru/technology/news/2022/12/15/955511-hartiyu-etiki','Ozon, ЦИАН и HeadHunter подписали хартию этики для классифайдов'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955500-v-moskve-personalu-rekomendovali',1,2,'2022-12-15 22:42:17+08','https://www.vedomosti.ru/society/news/2022/12/15/955500-v-moskve-personalu-rekomendovali','В Москве персоналу учреждений здравоохранения рекомендовали носить маски'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955506-putin-prizval-vivesti-novie-regioni-na-uroven',1,2,'2022-12-15 22:35:25+08','https://www.vedomosti.ru/society/news/2022/12/15/955506-putin-prizval-vivesti-novie-regioni-na-uroven','Путин призвал вывести новые регионы на общероссийский уровень по качеству жизни'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955507-genprokuratura-utverdila',1,2,'2022-12-15 22:32:25+08','https://www.vedomosti.ru/society/news/2022/12/15/955507-genprokuratura-utverdila','Генпрокуратура утвердила обвинение против Невзорова по делу о дискредитации ВС РФ'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955505-volodinu-federalnoi-palati-advokatov',1,2,'2022-12-15 22:19:38+08','https://www.vedomosti.ru/society/news/2022/12/15/955505-volodinu-federalnoi-palati-advokatov','Светлану Володину избрали президентом Федеральной палаты адвокатов РФ'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/15/955496-etsb-povisil-stavku',9,2,'2022-12-15 22:08:54+08','https://www.vedomosti.ru/economics/news/2022/12/15/955496-etsb-povisil-stavku','ЕЦБ повысил базовую процентную ставку на 50 б. п.'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955498-putin-raschet-zapada',10,2,'2022-12-15 22:01:05+08','https://www.vedomosti.ru/politics/news/2022/12/15/955498-putin-raschet-zapada','Путин заявил, что расчет Запада разрушить российскую экономику не оправдался');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955489-pushilin-zayavil-o-tselenapravlennih-udarah',1,2,'2022-12-15 21:54:08+08','https://www.vedomosti.ru/society/news/2022/12/15/955489-pushilin-zayavil-o-tselenapravlennih-udarah','Пушилин заявил о целенаправленных ударах ВСУ по жилым домам Донецка'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955491-putin-ipoteku',1,2,'2022-12-15 21:44:14+08','https://www.vedomosti.ru/society/news/2022/12/15/955491-putin-ipoteku','Путин предложил предоставлять ипотеку под 2% в новых регионах РФ'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/15/955480-putin-nazval-sanktsii-stimulom',9,2,'2022-12-15 21:16:55+08','https://www.vedomosti.ru/economics/news/2022/12/15/955480-putin-nazval-sanktsii-stimulom','Путин назвал санкции стимулом для развития суверенной экономики'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955485-putin-anonsiroval-uvelichenie-razmera',1,2,'2022-12-15 21:09:56+08','https://www.vedomosti.ru/society/news/2022/12/15/955485-putin-anonsiroval-uvelichenie-razmera','Путин анонсировал увеличение размера пособия для беременных'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/15/955486-programma-lgotnoi-ipoteki-prodlena',9,2,'2022-12-15 21:08:39+08','https://www.vedomosti.ru/economics/news/2022/12/15/955486-programma-lgotnoi-ipoteki-prodlena','Программа льготной ипотеки будет продлена до 1 июля 2024 года'),
	 ('https://www.vedomosti.ru/business/news/2022/12/15/955483-ericsson-prodazhe-biznesa',9,2,'2022-12-15 21:06:35+08','https://www.vedomosti.ru/business/news/2022/12/15/955483-ericsson-prodazhe-biznesa','Ericsson объявила о продаже бизнеса по поддержке клиентов в России'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955476-rossiya-prodolzhaet-pomogat',10,2,'2022-12-15 21:04:58+08','https://www.vedomosti.ru/politics/news/2022/12/15/955476-rossiya-prodolzhaet-pomogat','Путин: Россия продолжает помогать беднейшим странам поставками продовольствия'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955475-putin-nazval-bezumiem-politiku-es-po-tsenam-na-gaz',10,2,'2022-12-15 20:41:22+08','https://www.vedomosti.ru/politics/news/2022/12/15/955475-putin-nazval-bezumiem-politiku-es-po-tsenam-na-gaz','Путин назвал безумием политику ЕС по ценам на газ'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/15/955477-putin-nazval-snizhenie-urovnya-bednosti-dvizheniem',9,2,'2022-12-15 20:37:40+08','https://www.vedomosti.ru/economics/news/2022/12/15/955477-putin-nazval-snizhenie-urovnya-bednosti-dvizheniem','Путин назвал снижение уровня бедности до 10,5% «движением в правильном направлении»'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955470-v-minprosvescheniya-nazvali-sroki-provedeniya-ege',1,2,'2022-12-15 20:31:04+08','https://www.vedomosti.ru/society/news/2022/12/15/955470-v-minprosvescheniya-nazvali-sroki-provedeniya-ege','В Минпросвещения назвали сроки проведения ЕГЭ и ОГЭ в 2023 году');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955472-imenem-zhirinovskogo-nazovut-ulitsu-krasnodare',1,2,'2022-12-15 20:30:39+08','https://www.vedomosti.ru/society/news/2022/12/15/955472-imenem-zhirinovskogo-nazovut-ulitsu-krasnodare','Именем Жириновского назовут улицу в Краснодаре'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/15/955471-putin-v-sleduyuschem-godu-byudzhet-rossii-budet-ispolnen',9,2,'2022-12-15 20:26:36+08','https://www.vedomosti.ru/economics/news/2022/12/15/955471-putin-v-sleduyuschem-godu-byudzhet-rossii-budet-ispolnen','Путин: в следующем году бюджет будет исполнен с дефицитом около 2% ВВП'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955468-putin-rubl',10,2,'2022-12-15 20:23:31+08','https://www.vedomosti.ru/politics/news/2022/12/15/955468-putin-rubl','Путин назвал рубль одной из самых сильных валют мира'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955467-minoboroni-soobschilo-unichtozhenii-dvuh-diversionno-razvedivatelnih-grupp-vsu',10,2,'2022-12-15 20:19:53+08','https://www.vedomosti.ru/politics/news/2022/12/15/955467-minoboroni-soobschilo-unichtozhenii-dvuh-diversionno-razvedivatelnih-grupp-vsu','Минобороны сообщило об уничтожении двух диверсионных групп ВСУ в ДНР'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955464-mid-peredacha-baku-ukraine-generatorov-v-kachestve-pomoschi-vizivaet-nedoumenie',10,2,'2022-12-15 20:17:37+08','https://www.vedomosti.ru/politics/news/2022/12/15/955464-mid-peredacha-baku-ukraine-generatorov-v-kachestve-pomoschi-vizivaet-nedoumenie','МИД: передача Баку Украине генераторов в качестве помощи вызывает недоумение'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955463-novuyu-kontseptsiyu-vneshnei-politiki-rossii-mogut-opublikovat',10,2,'2022-12-15 20:11:08+08','https://www.vedomosti.ru/politics/news/2022/12/15/955463-novuyu-kontseptsiyu-vneshnei-politiki-rossii-mogut-opublikovat','Новую концепцию внешней политики России могут опубликовать в начале 2023 года'),
	 ('https://www.vedomosti.ru/business/news/2022/12/15/955458-fennovoima-rosatomom',9,2,'2022-12-15 20:00:57+08','https://www.vedomosti.ru/business/news/2022/12/15/955458-fennovoima-rosatomom','Расторжение контракта между Fennovoima и «Росатомом» сочли неправомерным'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955456-v-belgorodskoi-soobschili-ob-obstrele',10,2,'2022-12-15 19:48:27+08','https://www.vedomosti.ru/politics/news/2022/12/15/955456-v-belgorodskoi-soobschili-ob-obstrele','В Белгородской области сообщили об обстреле села Старый Хутор'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955454-gosduma-markirovki',1,2,'2022-12-15 19:39:14+08','https://www.vedomosti.ru/society/news/2022/12/15/955454-gosduma-markirovki','Госдума приняла закон об упрощении возрастной маркировки для фильмов и книг'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955451-es-ischet-sredstva',10,2,'2022-12-15 19:34:44+08','https://www.vedomosti.ru/politics/news/2022/12/15/955451-es-ischet-sredstva','В Польше заявили, что ЕС ищет средства для введения потолка цен на газ');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/business/news/2022/12/15/955453-mask-prodal-chast-tesla',9,2,'2022-12-15 19:23:13+08','https://www.vedomosti.ru/business/news/2022/12/15/955453-mask-prodal-chast-tesla','Маск продал часть своих акций Tesla на $3,6 млрд'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955449-rospotrebnadzore',1,2,'2022-12-15 19:12:15+08','https://www.vedomosti.ru/society/news/2022/12/15/955449-rospotrebnadzore','В Роспотребнадзоре исключили возможность введения ограничений из-за гриппа и ОРВИ'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955445-mid-poluchil-ot-vatikana-izvineniya-za-slova-papi-rimskogo',10,2,'2022-12-15 18:47:38+08','https://www.vedomosti.ru/politics/news/2022/12/15/955445-mid-poluchil-ot-vatikana-izvineniya-za-slova-papi-rimskogo','МИД получил от Ватикана извинения за слова папы римского о чеченцах и бурятах'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/15/955431-mintsifri-zayavilo-o-planah-obyazat-apple',6,2,'2022-12-15 18:38:05+08','https://www.vedomosti.ru/technology/news/2022/12/15/955431-mintsifri-zayavilo-o-planah-obyazat-apple','Минцифры заявило о планах обязать Apple разрешить установку сторонних приложений'),
	 ('https://www.vedomosti.ru/business/news/2022/12/15/955443-yandeks-predstavil-sobstvennii-elektrosamokat',9,2,'2022-12-15 18:36:32+08','https://www.vedomosti.ru/business/news/2022/12/15/955443-yandeks-predstavil-sobstvennii-elektrosamokat','«Яндекс» представил собственный электросамокат'),
	 ('https://www.vedomosti.ru/business/news/2022/12/15/955439-proizvoditel-upakovki-mondi-prodast-biznes-v-rossii',9,2,'2022-12-15 18:28:29+08','https://www.vedomosti.ru/business/news/2022/12/15/955439-proizvoditel-upakovki-mondi-prodast-biznes-v-rossii','Производитель упаковки Mondi продаст бизнес в России за 1,6 млрд рублей'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955435-pushilin-zayavil-ob-osvobozhdenii-marinki-na-80',10,2,'2022-12-15 18:19:36+08','https://www.vedomosti.ru/politics/news/2022/12/15/955435-pushilin-zayavil-ob-osvobozhdenii-marinki-na-80','Пушилин заявил об освобождении Марьинки на 80%'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955432-v-kremle-sochli-rezolyutsiyu-polshi-prodolzheniem-antirossiiskoi-isteriki',10,2,'2022-12-15 18:02:21+08','https://www.vedomosti.ru/politics/news/2022/12/15/955432-v-kremle-sochli-rezolyutsiyu-polshi-prodolzheniem-antirossiiskoi-isteriki','В Кремле сочли резолюцию Польши о России продолжением антироссийской истерики'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955429-peskov-prokommentiroval-vozvraschenie-sanktsii-dlya-severnogo-potoka',10,2,'2022-12-15 17:53:55+08','https://www.vedomosti.ru/politics/news/2022/12/15/955429-peskov-prokommentiroval-vozvraschenie-sanktsii-dlya-severnogo-potoka','Песков прокомментировал возвращение санкций в отношении турбин для «Северного потока»'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/15/955427-roskosmos-soobschil-o-povrezhdenii-obshivki-soyuza',1,2,'2022-12-15 17:39:48+08','https://www.vedomosti.ru/technology/news/2022/12/15/955427-roskosmos-soobschil-o-povrezhdenii-obshivki-soyuza','«Роскосмос» сообщил о повреждении обшивки «Союза МС-22»');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955426-v-kremle-prokommentirovali-sluhi-o-smene-glavi-mid',10,2,'2022-12-15 17:30:52+08','https://www.vedomosti.ru/politics/news/2022/12/15/955426-v-kremle-prokommentirovali-sluhi-o-smene-glavi-mid','В Кремле прокомментировали слухи о смене главы российского МИД'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955425-peskov-otvetnie-meri-na-potolok-tsen',10,2,'2022-12-15 17:30:25+08','https://www.vedomosti.ru/politics/news/2022/12/15/955425-peskov-otvetnie-meri-na-potolok-tsen','Песков: ответные меры на потолок цен на нефть ожидаются на этой неделе'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955417-v-kirgizii-ministru-ne-vistupit-na-russkom',10,2,'2022-12-15 17:06:18+08','https://www.vedomosti.ru/politics/news/2022/12/15/955417-v-kirgizii-ministru-ne-vistupit-na-russkom','В Кыргызстане министру не дали выступить в парламенте на русском языке'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955423-v-es-vnov-ne-smogli-soglasovat-devyatii-paket-sanktsii',10,2,'2022-12-15 17:05:35+08','https://www.vedomosti.ru/politics/news/2022/12/15/955423-v-es-vnov-ne-smogli-soglasovat-devyatii-paket-sanktsii','В ЕС вновь не смогли согласовать девятый пакет санкций против России'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/15/955414-mehanizm-blokirovki-avtoobzvona',6,2,'2022-12-15 16:57:56+08','https://www.vedomosti.ru/technology/news/2022/12/15/955414-mehanizm-blokirovki-avtoobzvona','Минцифры предложило операторам связи ввести механизм блокировки автообзвона'),
	 ('https://www.vedomosti.ru/business/news/2022/12/15/955416-tts-nachali-massovo-podavat-iski-k-hm',9,2,'2022-12-15 16:52:40+08','https://www.vedomosti.ru/business/news/2022/12/15/955416-tts-nachali-massovo-podavat-iski-k-hm','«Известия»: ТЦ начали подавать иски к H&M из-за неуплаты аренды в 1 млрд рублей'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955409-pravitelstvo-utverdilo-testirovanie-na-gripp',1,2,'2022-12-15 16:35:46+08','https://www.vedomosti.ru/society/news/2022/12/15/955409-pravitelstvo-utverdilo-testirovanie-na-gripp','В больницах и поликлиниках начнут бесплатно тестировать на грипп'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955406-chislo-postradavshih-pri-obstrele-donetska-viroslo',1,2,'2022-12-15 16:26:35+08','https://www.vedomosti.ru/society/news/2022/12/15/955406-chislo-postradavshih-pri-obstrele-donetska-viroslo','Число пострадавших при обстреле Донецка выросло до девяти'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955404-mchs-provedet-vneplanovie-proverki-krupnih-trts',1,2,'2022-12-15 16:05:56+08','https://www.vedomosti.ru/society/news/2022/12/15/955404-mchs-provedet-vneplanovie-proverki-krupnih-trts','МЧС проведет внеплановые проверки крупных ТРЦ и складов после пожаров'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955399-zhitelya-habarovska-osudili-za-popitku-prodat-sekretnie-dannie',1,2,'2022-12-15 16:01:09+08','https://www.vedomosti.ru/society/news/2022/12/15/955399-zhitelya-habarovska-osudili-za-popitku-prodat-sekretnie-dannie','Жителя Хабаровска осудили за попытку продать секретные данные спецслужбам Украины');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/finance/news/2022/12/15/955388-pravitelstvo-predlozhilo-konvertirovat-doli-rf-v-mezhdunarodnih-finorganizatsiyah',9,2,'2022-12-15 15:58:02+08','https://www.vedomosti.ru/finance/news/2022/12/15/955388-pravitelstvo-predlozhilo-konvertirovat-doli-rf-v-mezhdunarodnih-finorganizatsiyah','Правительство предложило конвертировать доли РФ в международных финорганизациях в долг'),
	 ('https://www.vedomosti.ru/finance/news/2022/12/15/955400-sberbank-otklyuchil-perevodi-v-drugie-banki',9,2,'2022-12-15 15:50:21+08','https://www.vedomosti.ru/finance/news/2022/12/15/955400-sberbank-otklyuchil-perevodi-v-drugie-banki','Сбербанк отключил переводы в другие банки через банкоматы'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955397-aksenov-nazval-bespilotniki-glavnoi-ugrozoi',10,2,'2022-12-15 15:49:46+08','https://www.vedomosti.ru/politics/news/2022/12/15/955397-aksenov-nazval-bespilotniki-glavnoi-ugrozoi','Аксенов назвал беспилотники главной угрозой для Крыма'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/15/955387-rossiya-mozhet-prodlit-zapret-na-vezd-gruzovikov',9,2,'2022-12-15 15:44:03+08','https://www.vedomosti.ru/economics/news/2022/12/15/955387-rossiya-mozhet-prodlit-zapret-na-vezd-gruzovikov','РБК: Россия может продлить запрет на въезд грузовиков из ЕС до июля 2023 года'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955385-alihanov-rasskazal-o-priezzhayuschih-v-kaliningradskuyu-oblast-nemtsah',1,2,'2022-12-15 15:40:51+08','https://www.vedomosti.ru/society/news/2022/12/15/955385-alihanov-rasskazal-o-priezzhayuschih-v-kaliningradskuyu-oblast-nemtsah','Алиханов рассказал о приезжающих в Калининградскую область на зиму немцах'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955384-v-rossii-vpervie-oshtrafovali-inoagenta-za-shrift',1,2,'2022-12-15 15:00:45+08','https://www.vedomosti.ru/society/news/2022/12/15/955384-v-rossii-vpervie-oshtrafovali-inoagenta-za-shrift','В России впервые оштрафовали иноагента за недостаточно большой размер шрифта'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955382-zabolevaemost-grippom-virosla',1,2,'2022-12-15 14:41:49+08','https://www.vedomosti.ru/society/news/2022/12/15/955382-zabolevaemost-grippom-virosla','Заболеваемость гриппом в 2022 году выросла в 11 раз'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955381-volodin-nazval-zakon-o-legalizatsii-odnopolih-brakov',10,2,'2022-12-15 14:30:44+08','https://www.vedomosti.ru/politics/news/2022/12/15/955381-volodin-nazval-zakon-o-legalizatsii-odnopolih-brakov','Володин назвал закон об однополых браках в США путем к «вырождению нации»'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/15/955380-vihod-v-otkritii-kosmos-kosmonavtov-otmenili',1,2,'2022-12-15 14:25:32+08','https://www.vedomosti.ru/technology/news/2022/12/15/955380-vihod-v-otkritii-kosmos-kosmonavtov-otmenili','Выход в открытый космос российских космонавтов снова отменили'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955379-politico-soobschil-o-planah-es-opublikovat-zayavlenie',10,2,'2022-12-15 14:12:00+08','https://www.vedomosti.ru/politics/news/2022/12/15/955379-politico-soobschil-o-planah-es-opublikovat-zayavlenie','Politico сообщило о планах ЕС опубликовать призыв к России «покинуть Украину»');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955377-kanada-vosstanovila-sanktsii-protiv-turbin-dlya-severnogo',10,2,'2022-12-15 13:43:46+08','https://www.vedomosti.ru/politics/news/2022/12/15/955377-kanada-vosstanovila-sanktsii-protiv-turbin-dlya-severnogo','Канада восстановила санкции против турбин для «Северного потока»'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955376-v-donetske-soobschili-o-samom-massirovannom-obstrele',10,2,'2022-12-15 13:20:11+08','https://www.vedomosti.ru/politics/news/2022/12/15/955376-v-donetske-soobschili-o-samom-massirovannom-obstrele','В Донецке сообщили о самом массированном обстреле с 2014 года'),
	 ('https://www.vedomosti.ru/society/news/2022/12/15/955375-pri-pozhare-v-angarske-pogibli-dva-cheloveka',1,2,'2022-12-15 12:47:12+08','https://www.vedomosti.ru/society/news/2022/12/15/955375-pri-pozhare-v-angarske-pogibli-dva-cheloveka','При пожаре на нефтезаводе в Ангарске погибли два человека'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/15/955374-posolstvo-rossii-predupredilo-ssha-o-posledstviyah',10,2,'2022-12-15 12:22:41+08','https://www.vedomosti.ru/politics/news/2022/12/15/955374-posolstvo-rossii-predupredilo-ssha-o-posledstviyah','Посольство России предупредило США о последствиях в случае отправки ЗРК Patriot Киеву'),
	 ('https://www.vedomosti.ru/business/news/2022/12/14/955364-pravitelstvo-postanovilo-uvelichit-rzhd',9,2,'2022-12-15 03:59:47+08','https://www.vedomosti.ru/business/news/2022/12/14/955364-pravitelstvo-postanovilo-uvelichit-rzhd','Правительство постановило увеличить уставный капитал РЖД на 217 млрд рублей'),
	 ('https://www.vedomosti.ru/business/news/2022/12/14/955356-dolya-shell-otsenena',9,2,'2022-12-15 03:36:38+08','https://www.vedomosti.ru/business/news/2022/12/14/955356-dolya-shell-otsenena','Доля Shell в проекте «Сахалин-2» оценена в 94,8 млрд рублей'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/14/955352-belii-dom-prodolzhaet-izuchat',10,2,'2022-12-15 03:28:21+08','https://www.vedomosti.ru/politics/news/2022/12/14/955352-belii-dom-prodolzhaet-izuchat','Белый дом продолжает изучать идею о создании трибунала по Украине'),
	 ('https://www.vedomosti.ru/society/news/2022/12/14/955346-v-peterburge-dosrochnie-kanikuli',1,2,'2022-12-15 03:13:52+08','https://www.vedomosti.ru/society/news/2022/12/14/955346-v-peterburge-dosrochnie-kanikuli','В Петербурге решили устроить младшеклассникам досрочные каникулы из-за гриппа'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/14/955340-ssha-mogut-vvesti-sanktsii',10,2,'2022-12-15 02:53:53+08','https://www.vedomosti.ru/politics/news/2022/12/14/955340-ssha-mogut-vvesti-sanktsii','WSJ: США могут ввести санкции против Потанина и некоторых его компаний'),
	 ('https://www.vedomosti.ru/society/news/2022/12/14/955338-dva-mirnih-zhitelya-pogibli',1,2,'2022-12-15 02:36:26+08','https://www.vedomosti.ru/society/news/2022/12/14/955338-dva-mirnih-zhitelya-pogibli','Два мирных жителя погибли в результате обстрела ДНР со стороны ВСУ');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/society/news/2022/12/14/955335-mintsifri-vistupilo-protiv',1,2,'2022-12-15 02:25:32+08','https://www.vedomosti.ru/society/news/2022/12/14/955335-mintsifri-vistupilo-protiv','Минцифры выступило против запрета сотрудникам IT-компаний работать из-за границы'),
	 ('https://www.vedomosti.ru/society/news/2022/12/14/955334-pvo-sbila-raketi',1,2,'2022-12-15 02:07:06+08','https://www.vedomosti.ru/society/news/2022/12/14/955334-pvo-sbila-raketi','ПВО сбила украинские ракеты над Клинцами Брянской области'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/14/955333-tramp-anonsiroval',10,2,'2022-12-15 01:54:07+08','https://www.vedomosti.ru/politics/news/2022/12/14/955333-tramp-anonsiroval','Трамп анонсировал «важное объявление» 15 декабря'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/14/955332-belii-dom-ne-podtverdil-patriot',10,2,'2022-12-15 01:35:45+08','https://www.vedomosti.ru/politics/news/2022/12/14/955332-belii-dom-ne-podtverdil-patriot','Белый дом не подтвердил поставку ЗРК Patriot Украине в рамках будущего пакета помощи'),
	 ('https://www.vedomosti.ru/society/news/2022/12/14/955330-zhitelyu-udmurtii-dali',1,2,'2022-12-15 01:06:13+08','https://www.vedomosti.ru/society/news/2022/12/14/955330-zhitelyu-udmurtii-dali','Жителю Удмуртии дали 5 лет за попытку участия в боевых действиях против России'),
	 ('https://www.vedomosti.ru/society/news/2022/12/14/955328-prokuratura-poprosila-izyat',1,2,'2022-12-15 00:19:42+08','https://www.vedomosti.ru/society/news/2022/12/14/955328-prokuratura-poprosila-izyat','Прокуратура попросила изъять имущество экс-полковника Захарченко на 50 млн рублей'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/14/955322-nedelnaya-inflyatsiya-zamedlilas',9,2,'2022-12-15 00:10:26+08','https://www.vedomosti.ru/economics/news/2022/12/14/955322-nedelnaya-inflyatsiya-zamedlilas','Недельная инфляция в России замедлилась до 0,19%'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/14/955320-glava-magate-mozhet-priehat',10,2,'2022-12-14 23:49:31+08','https://www.vedomosti.ru/politics/news/2022/12/14/955320-glava-magate-mozhet-priehat','Глава МАГАТЭ может приехать в Москву до конца этого года'),
	 ('https://www.vedomosti.ru/business/news/2022/12/14/955311-putin-podderzhal-vidachu-elektronnih',9,2,'2022-12-14 23:39:16+08','https://www.vedomosti.ru/business/news/2022/12/14/955311-putin-podderzhal-vidachu-elektronnih','Путин поддержал выдачу электронных разрешений и лицензий для бизнеса'),
	 ('https://www.vedomosti.ru/finance/news/2022/12/14/955318-kurs-dollara-previsil',9,2,'2022-12-14 23:32:47+08','https://www.vedomosti.ru/finance/news/2022/12/14/955318-kurs-dollara-previsil','Курс доллара на Мосбирже превысил 64 рубля впервые с октября');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/relations/',1,1,'2022-12-19 16:33:00+08','https://lenta.ru/news/2022/12/19/relations/','Психолог назвала причины скуки в стабильных отношениях'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/14/955308-mid-nazval-slova-sholtsa',10,2,'2022-12-14 23:20:18+08','https://www.vedomosti.ru/politics/news/2022/12/14/955308-mid-nazval-slova-sholtsa','МИД назвал слова Шольца о России попыткой оправдаться за проблемы ФРГ'),
	 ('https://tass.ru/proisshestviya/16623819',7,3,'2022-12-18 16:32:48+08','https://tass.ru/proisshestviya/16623819','В Челябинской области при пожаре в торговом центре пострадал один человек'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623825',4,3,'2022-12-18 16:31:33+08','https://tass.ru/mezhdunarodnaya-panorama/16623825','Министр обороны Италии считает бесполезным выделять на оборону более 2% ВВП'),
	 ('https://tass.ru/obschestvo/16623811',1,3,'2022-12-18 16:29:30+08','https://tass.ru/obschestvo/16623811','Кузнецова: нужно создать комплексную программу для реабилитации детей из новых регионов'),
	 ('https://tass.ru/proisshestviya/16623799',7,3,'2022-12-18 16:26:03+08','https://tass.ru/proisshestviya/16623799','В Ульяновской области произошли частичные отключения света в 13 населенных пунктах'),
	 ('https://tass.ru/obschestvo/16623803',1,3,'2022-12-18 16:22:07+08','https://tass.ru/obschestvo/16623803','Кабмин расширил перечень премий, которые освобождаются от НДФЛ'),
	 ('https://tass.ru/sport/16623793',8,3,'2022-12-18 16:21:21+08','https://tass.ru/sport/16623793','Йоканович назвал умершего от лейкемии бывшего футболиста Михайловича сильным мужчиной'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623795',4,3,'2022-12-18 16:19:53+08','https://tass.ru/mezhdunarodnaya-panorama/16623795','В Республике Фиджи по итогам выборов будет сформировано коалиционное правительство'),
	 ('https://tass.ru/proisshestviya/16623789',7,3,'2022-12-18 16:18:31+08','https://tass.ru/proisshestviya/16623789','Прокуратура проверит обстоятельства падения зрительницы в оркестровую яму в Саратове');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623781',4,3,'2022-12-18 16:17:29+08','https://tass.ru/mezhdunarodnaya-panorama/16623781','СМИ: Греция помимо оружия и боеприпасов отправляет на Украину миллионы евро'),
	 ('https://tass.ru/obschestvo/16623771',1,3,'2022-12-18 16:13:29+08','https://tass.ru/obschestvo/16623771','В Крыму объявили штормовое предупреждение из-за сильного ветра'),
	 ('https://tass.ru/obschestvo/16623777',1,3,'2022-12-18 16:12:49+08','https://tass.ru/obschestvo/16623777','В Южной Осетии заявили о предвзятом применении норм международного права к своим гражданам'),
	 ('https://tass.ru/obschestvo/16623753',1,3,'2022-12-18 16:10:30+08','https://tass.ru/obschestvo/16623753','Пострадавший при пожаре в Саратовской области мальчик идет на поправку'),
	 ('https://tass.ru/obschestvo/16623745',1,3,'2022-12-18 16:00:40+08','https://tass.ru/obschestvo/16623745','В России за сутки выявили 7 222 случая заражения коронавирусом'),
	 ('https://tass.ru/ekonomika/16623729',9,3,'2022-12-18 15:57:30+08','https://tass.ru/ekonomika/16623729','В Харькове и Кривом Роге восстановили энергоснабжение'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623723',4,3,'2022-12-18 15:54:20+08','https://tass.ru/mezhdunarodnaya-panorama/16623723','Турция передала ВС Грузии авиационную технику'),
	 ('https://tass.ru/obschestvo/16623689',5,3,'2022-12-18 15:53:58+08','https://tass.ru/obschestvo/16623689','Высота сугробов в Московском регионе достигла 38-43 см'),
	 ('https://tass.ru/obschestvo/16623713',1,3,'2022-12-18 15:53:19+08','https://tass.ru/obschestvo/16623713','Мишустин поздравил премьер-министра Казахстана с 50-летием'),
	 ('https://tass.ru/proisshestviya/16623677',7,3,'2022-12-18 15:48:24+08','https://tass.ru/proisshestviya/16623677','В Чувашии более 2,7 тыс. домов остались без электричества из-за последствий ледяного дождя');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/obschestvo/16623695',1,3,'2022-12-18 15:48:22+08','https://tass.ru/obschestvo/16623695','Папа Римский сообщил, что подписал документ об отречении на случай серьезной болезни'),
	 ('https://tass.ru/sport/16623681',8,3,'2022-12-18 15:44:54+08','https://tass.ru/sport/16623681','Матыцин возложил полномочия президента FISU на Эдера и может вернуться на пост'),
	 ('https://tass.ru/obschestvo/16623671',1,3,'2022-12-18 15:38:38+08','https://tass.ru/obschestvo/16623671','Большинство японцев не поддерживает идею повышения налогов ради расходов на оборону'),
	 ('https://tass.ru/ekonomika/16623661',9,3,'2022-12-18 15:38:17+08','https://tass.ru/ekonomika/16623661','Товарооборот Китая и Украины в январе - ноябре упал на 59%'),
	 ('https://tass.ru/ekonomika/16623643',5,3,'2022-12-18 15:30:12+08','https://tass.ru/ekonomika/16623643','На Курском вокзале открыли три новые платформы'),
	 ('https://tass.ru/sport/16623637',8,3,'2022-12-18 15:21:52+08','https://tass.ru/sport/16623637','ФХР обсудит вопрос создания женской сборной России по хоккею 3х3'),
	 ('https://tass.ru/obschestvo/16623635',1,3,'2022-12-18 15:20:43+08','https://tass.ru/obschestvo/16623635','В Ульяновске трамваи изменили маршрут движения из-за ледяного дождя'),
	 ('https://tass.ru/obschestvo/16623605',1,3,'2022-12-18 15:06:21+08','https://tass.ru/obschestvo/16623605','Почти половина опрошенных жителей ФРГ отметили негативное влияние миграции на страну'),
	 ('https://tass.ru/obschestvo/16623581',1,3,'2022-12-18 15:03:48+08','https://tass.ru/obschestvo/16623581','В Ульяновской области сняли ограничения движения на трассах'),
	 ('https://tass.ru/ekonomika/16623593',9,3,'2022-12-18 15:01:06+08','https://tass.ru/ekonomika/16623593','"Газпром" подает газ для Европы через Украину в объеме 42,3 млн куб. м через "Суджу"');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/obschestvo/16623573',5,3,'2022-12-18 15:00:09+08','https://tass.ru/obschestvo/16623573','В аэропортах Москвы задержали или отменили более 50 рейсов'),
	 ('https://tass.ru/obschestvo/16623585',1,3,'2022-12-18 14:59:59+08','https://tass.ru/obschestvo/16623585','В Киеве полностью восстановили отопление'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623567',4,3,'2022-12-18 14:58:07+08','https://tass.ru/mezhdunarodnaya-panorama/16623567','Армия Израиля сообщила о начале учений в районе Голанских высот и горы Хермон'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623557',4,3,'2022-12-18 14:53:33+08','https://tass.ru/mezhdunarodnaya-panorama/16623557','Папа Римский назвал конфликт на Украине "мировой войной"'),
	 ('https://tass.ru/proisshestviya/16623551',7,3,'2022-12-18 14:47:15+08','https://tass.ru/proisshestviya/16623551','При пожаре под Воронежем погибли два ребенка'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623535',4,3,'2022-12-18 14:37:15+08','https://tass.ru/mezhdunarodnaya-panorama/16623535','СМИ: Израиль депортировал во Францию палестинского правозащитника Салаха Хамури'),
	 ('https://tass.ru/obschestvo/16623533',1,3,'2022-12-18 14:29:24+08','https://tass.ru/obschestvo/16623533','В Туве кабинеты неотложной помощи перешли на режим работы без выходных'),
	 ('https://tass.ru/kultura/16623521',3,3,'2022-12-18 14:07:18+08','https://tass.ru/kultura/16623521','В КНР считают, что Хайнаньский кинофестиваль должен придать импульс развитию киноиндустрии'),
	 ('https://tass.ru/obschestvo/16623519',1,3,'2022-12-18 14:06:30+08','https://tass.ru/obschestvo/16623519','В Чувашии летом 2023 года пройдет первый форум многодетных семей'),
	 ('https://tass.ru/obschestvo/16623509',5,3,'2022-12-18 14:02:31+08','https://tass.ru/obschestvo/16623509','В нескольких районах Москвы восстановили движение трамваев');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/sport/16623511',8,3,'2022-12-18 14:00:46+08','https://tass.ru/sport/16623511','Колосков считает, что победой на чемпионате мира Месси подтвердит свою гениальность'),
	 ('https://tass.ru/obschestvo/16623479',1,3,'2022-12-18 13:10:00+08','https://tass.ru/obschestvo/16623479','Жапаров: работающие за рубежом трудовые мигранты из Киргизии развивают ее экономику'),
	 ('https://tass.ru/ekonomika/16623473',9,3,'2022-12-18 13:07:55+08','https://tass.ru/ekonomika/16623473','Дилеры ожидают роста цен на новые автомобили в начале 2023 года на 10%'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623451',4,3,'2022-12-18 13:01:05+08','https://tass.ru/mezhdunarodnaya-panorama/16623451','Лукашенко заявил о готовности принять эмира Катара в удобное для него время'),
	 ('https://tass.ru/proisshestviya/16623461',7,3,'2022-12-18 13:00:56+08','https://tass.ru/proisshestviya/16623461','Экс-главу Тынды арестовали по делу о злоупотреблении должностными полномочиями'),
	 ('https://tass.ru/obschestvo/16623459',5,3,'2022-12-18 12:55:28+08','https://tass.ru/obschestvo/16623459','В нескольких районах Москвы задерживаются трамваи'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623445',4,3,'2022-12-18 12:31:41+08','https://tass.ru/mezhdunarodnaya-panorama/16623445','В Сеуле заявили, что баллистические ракеты КНДР запустили из провинции Пхёнан-Пукто'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623417',4,3,'2022-12-18 12:12:17+08','https://tass.ru/mezhdunarodnaya-panorama/16623417','Yonhap: Ким Чен Ын, вероятно, не пришел в мавзолей по случаю годовщины смерти отца'),
	 ('https://tass.ru/ekonomika/16623407',9,3,'2022-12-18 12:08:17+08','https://tass.ru/ekonomika/16623407','Эксперт: промышленная кооперация ОЭЗ и СЭЗ стран Каспия поможет развитию МТК "Север - Юг"'),
	 ('https://tass.ru/sport/16623411',8,3,'2022-12-18 12:06:53+08','https://tass.ru/sport/16623411','Форвард "Тампы" Кучеров продлил свою результативную серию в НХЛ до семи матчей');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623375',4,3,'2022-12-18 11:40:49+08','https://tass.ru/mezhdunarodnaya-panorama/16623375','Минобороны Японии назвало расстояние и высоту полета ракет КНДР'),
	 ('https://tass.ru/obschestvo/16623365',1,3,'2022-12-18 11:37:25+08','https://tass.ru/obschestvo/16623365','В Иркутске за ночь выпала почти треть месячной нормы осадков'),
	 ('https://tass.ru/proisshestviya/16623353',7,3,'2022-12-18 11:27:11+08','https://tass.ru/proisshestviya/16623353','В ДНР сообщили об обстреле ВСУ Донецка из РСЗО "Град"'),
	 ('https://tass.ru/proisshestviya/16623349',7,3,'2022-12-18 11:24:48+08','https://tass.ru/proisshestviya/16623349','В Иркутской области возбудили дело о незаконном оформлении земли в собственность'),
	 ('https://tass.ru/proisshestviya/16623341',7,3,'2022-12-18 11:19:23+08','https://tass.ru/proisshestviya/16623341','В Атланте в результате стрельбы погибли два подростка'),
	 ('https://tass.ru/obschestvo/16623331',1,3,'2022-12-18 11:15:58+08','https://tass.ru/obschestvo/16623331','В двух районах Сахалинской области ожидаются ураганный ветер и снег'),
	 ('https://tass.ru/obschestvo/16623313',5,3,'2022-12-18 11:04:40+08','https://tass.ru/obschestvo/16623313','В Москве ожидается облачная погода и до 7 градусов мороза'),
	 ('https://tass.ru/politika/16623273',10,3,'2022-12-18 10:33:44+08','https://tass.ru/politika/16623273','Посол РФ: США втягиваются в украинский конфликт, утрачивая инстинкт самосохранения'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623261',4,3,'2022-12-18 10:24:37+08','https://tass.ru/mezhdunarodnaya-panorama/16623261','КНДР запустила две баллистические ракеты в сторону Японского моря'),
	 ('https://tass.ru/proisshestviya/16623253',7,3,'2022-12-18 10:14:17+08','https://tass.ru/proisshestviya/16623253','В ЛНР сообщили об украинском обстреле Алчевска из РСЗО HIMARS');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/armiya-i-opk/16623249',4,3,'2022-12-18 10:03:55+08','https://tass.ru/armiya-i-opk/16623249','Шойгу проинспектировал группировку войск в зоне спецоперации и на передовой'),
	 ('https://tass.ru/kultura/16623229',3,3,'2022-12-18 10:02:57+08','https://tass.ru/kultura/16623229','В Китае начался 4-й Хайнаньский международный кинофестиваль'),
	 ('https://tass.ru/obschestvo/16623225',1,3,'2022-12-18 09:50:02+08','https://tass.ru/obschestvo/16623225','На Камчатке умерла первая женщина, получившая в СССР звание "Снежный барс"'),
	 ('https://tass.ru/politika/16623217',10,3,'2022-12-18 09:49:08+08','https://tass.ru/politika/16623217','Посол РФ в Вашингтоне заявил, что США в своей политике застряли в эпохе холодной войны'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623211',4,3,'2022-12-18 09:46:37+08','https://tass.ru/mezhdunarodnaya-panorama/16623211','Явка на досрочных выборах в парламент Туниса составила около 9%'),
	 ('https://tass.ru/obschestvo/16623205',1,3,'2022-12-18 09:36:20+08','https://tass.ru/obschestvo/16623205','Аксенов заявил, что готовность строящейся соборной мечети Крыма превысила 85%'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623199',4,3,'2022-12-18 09:11:13+08','https://tass.ru/mezhdunarodnaya-panorama/16623199','В Пентагоне заявили о возможности расширения сотрудничества в разведке между США и Литвой'),
	 ('https://tass.ru/proisshestviya/16623191',7,3,'2022-12-18 08:58:50+08','https://tass.ru/proisshestviya/16623191','В ДНР сообщили об обстреле ВСУ Донецка и Ясиноватой из ствольной артиллерии'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623183',4,3,'2022-12-18 08:43:42+08','https://tass.ru/mezhdunarodnaya-panorama/16623183','Начальник Штаба обороны британских ВС заявил, что хотел бы чаще контактировать с Москвой'),
	 ('https://tass.ru/proisshestviya/16623175',7,3,'2022-12-18 08:20:01+08','https://tass.ru/proisshestviya/16623175','Во Владивостоке полностью ликвидировали крупный пожар на складах');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/obschestvo/16623167',1,3,'2022-12-18 08:15:02+08','https://tass.ru/obschestvo/16623167','В Канаде назвали предварительную причину гибели хоккеиста Казбекова'),
	 ('https://tass.ru/ekonomika/16623147',9,3,'2022-12-18 08:13:21+08','https://tass.ru/ekonomika/16623147','Аксенов: Крым предложит Белоруссии свои порты в качестве южных морских ворот ЕАЭС'),
	 ('https://tass.ru/obschestvo/16623163',1,3,'2022-12-18 08:04:51+08','https://tass.ru/obschestvo/16623163','Эксперт спрогнозировал спад заболеваемости гриппом в России после новогодних праздников'),
	 ('https://tass.ru/obschestvo/16623137',1,3,'2022-12-18 07:56:09+08','https://tass.ru/obschestvo/16623137','В Марокко прошел концерт русской музыки в исполнении ансамбля "Вера"'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623129',4,3,'2022-12-18 07:48:30+08','https://tass.ru/mezhdunarodnaya-panorama/16623129','СМИ: в Ливане разыскивают двух человек после выстрелов в ирландских миротворцев ООН'),
	 ('https://tass.ru/proisshestviya/16623125',7,3,'2022-12-18 07:37:46+08','https://tass.ru/proisshestviya/16623125','На востоке ЮАР из-за сильной волны погибли три человека'),
	 ('https://tass.ru/sport/16623115',8,3,'2022-12-18 07:18:52+08','https://tass.ru/sport/16623115','Президент Аргентины сообщил, что будет смотреть финал чемпионата мира по футболу дома'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623109',4,3,'2022-12-18 07:17:40+08','https://tass.ru/mezhdunarodnaya-panorama/16623109','NYT: в США проверяют крупные пожертвования основателя биржи FTX политикам'),
	 ('https://tass.ru/sport/16623103',8,3,'2022-12-18 07:15:22+08','https://tass.ru/sport/16623103','На улицах Загреба болельщики празднуют победу своей сборной над Марокко'),
	 ('https://tass.ru/obschestvo/16623101',5,3,'2022-12-18 07:06:24+08','https://tass.ru/obschestvo/16623101','Вильфанд спрогнозировал оттепель в Москве с 21 декабря');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/kosmos/16623093',6,3,'2022-12-18 06:46:25+08','https://tass.ru/kosmos/16623093','SpaceX вывела в космос еще 54 мини-спутника для Starlink'),
	 ('https://tass.ru/obschestvo/16623091',1,3,'2022-12-18 06:46:15+08','https://tass.ru/obschestvo/16623091','Лайнер Astoria Grande впервые отправился в зимний круиз из Сочи в Турцию'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623087',4,3,'2022-12-18 06:06:36+08','https://tass.ru/mezhdunarodnaya-panorama/16623087','Греция выделит €5,65 млрд в госбюджете на оборону в 2023 году'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623079',4,3,'2022-12-18 05:45:16+08','https://tass.ru/mezhdunarodnaya-panorama/16623079','В Приднестровье заявили, что около 65% лекарств не поступают в республику из-за Молдавии'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623067',4,3,'2022-12-18 05:42:30+08','https://tass.ru/mezhdunarodnaya-panorama/16623067','Замминистра финансов США обсудил с коллегами из ФРГ санкции против РФ и помощь Украине'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623061',4,3,'2022-12-18 05:41:05+08','https://tass.ru/mezhdunarodnaya-panorama/16623061','Spiegel: ВС ФРГ испытывают серьезные проблемы с техническим состоянием БМП Puma'),
	 ('https://tass.ru/kultura/16623041',5,3,'2022-12-18 05:18:16+08','https://tass.ru/kultura/16623041','Театр "Сфера" представит французскую комедию "Подсвечник"'),
	 ('https://tass.ru/kultura/16623031',3,3,'2022-12-18 05:15:55+08','https://tass.ru/kultura/16623031','Мариинский театр отметит 130-летие мировой премьеры на своей сцене балета "Щелкунчик"'),
	 ('https://tass.ru/obschestvo/16623059',1,3,'2022-12-18 05:15:18+08','https://tass.ru/obschestvo/16623059','Эксперт: перенесшие коронавирусную инфекцию тяжелее болеют гриппом'),
	 ('https://tass.ru/obschestvo/16623021',1,3,'2022-12-18 05:11:42+08','https://tass.ru/obschestvo/16623021','На Кипре пройдет первый этап выборов главы православной церкви');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/politika/16623053',10,3,'2022-12-18 05:10:50+08','https://tass.ru/politika/16623053','ЛДПР открыла региональное отделение в ЛНР'),
	 ('https://tass.ru/obschestvo/16623013',5,3,'2022-12-18 05:05:33+08','https://tass.ru/obschestvo/16623013','В Москве откроется первый съезд Российского движения детей и молодежи'),
	 ('https://tass.ru/sport/16623045',8,3,'2022-12-18 05:02:31+08','https://tass.ru/sport/16623045','Сборные Аргентины и Франции сыграют в финале чемпионата мира по футболу'),
	 ('https://tass.ru/armiya-i-opk/16620013',4,3,'2022-12-18 05:00:00+08','https://tass.ru/armiya-i-opk/16620013','Военная операция на Украине. Онлайн'),
	 ('https://tass.ru/obschestvo/16622997',1,3,'2022-12-18 04:43:51+08','https://tass.ru/obschestvo/16622997','Посольство РФ в Канаде готово оказать необходимую помощь родным хоккеиста Казбекова'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623005',4,3,'2022-12-18 04:43:04+08','https://tass.ru/mezhdunarodnaya-panorama/16623005','Лео Варадкар стал новым премьером Ирландии'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16622989',4,3,'2022-12-18 04:40:45+08','https://tass.ru/mezhdunarodnaya-panorama/16622989','Энергетики Киева назвали ситуацию с электроснабжением в городе далекой от стабилизации'),
	 ('https://tass.ru/kultura/16622981',5,3,'2022-12-18 04:27:45+08','https://tass.ru/kultura/16622981','В Москве состоялась премьера фильма "Мажор в Сочи"'),
	 ('https://tass.ru/ekonomika/16622923',9,3,'2022-12-18 04:07:11+08','https://tass.ru/ekonomika/16622923','Росатом заявил о необходимости по-новому использовать ледоколы из-за роста нагрузки на СМП'),
	 ('https://tass.ru/obschestvo/16622943',1,3,'2022-12-18 03:58:55+08','https://tass.ru/obschestvo/16622943','Макрон посетит авианосец "Шарль-де-Голль" у берегов Египта');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/proisshestviya/16622935',7,3,'2022-12-18 03:55:00+08','https://tass.ru/proisshestviya/16622935','Зеленский сообщил о серьезных проблемах с водоснабжением на Украине'),
	 ('https://tass.ru/politika/16622973',10,3,'2022-12-18 03:54:28+08','https://tass.ru/politika/16622973','Посол РФ в Сербии покинул съезд соцпартии после ролика с заявлениями Ципраса'),
	 ('https://lenta.ru/news/2022/12/18/belg/',5,1,'2022-12-18 18:33:22+08','https://lenta.ru/news/2022/12/18/belg/','В небе над Белгородом произошла серия взрывов'),
	 ('https://lenta.ru/news/2022/12/18/mid_berlin/',4,1,'2022-12-18 18:22:00+08','https://lenta.ru/news/2022/12/18/mid_berlin/','Германия отвергла прекращение огня на Украине на российских условиях'),
	 ('https://lenta.ru/news/2022/12/18/mid_berlin/',10,1,'2022-12-18 18:22:00+08','https://lenta.ru/news/2022/12/18/mid_berlin/','Германия отвергла прекращение огня на Украине на российских условиях'),
	 ('https://lenta.ru/news/2022/12/18/airlines/',1,1,'2022-12-18 18:18:00+08','https://lenta.ru/news/2022/12/18/airlines/','Во Внуково сотни людей высадили из самолета без объяснения причин'),
	 ('https://lenta.ru/news/2022/12/18/cosmoss/',6,1,'2022-12-18 18:15:00+08','https://lenta.ru/news/2022/12/18/cosmoss/','В «Роскосмосе» рассказали о ситуации на поврежденном «Союзе МС-2»'),
	 ('https://lenta.ru/news/2022/12/18/ukren/',4,1,'2022-12-18 18:15:00+08','https://lenta.ru/news/2022/12/18/ukren/','Подконтрольные Киеву АЭС вышли на плановую мощность'),
	 ('https://lenta.ru/news/2022/12/18/helsinko/',4,1,'2022-12-18 18:12:00+08','https://lenta.ru/news/2022/12/18/helsinko/','В посольстве рассказали о проблеме с российскими туристами в Хельсинки'),
	 ('https://lenta.ru/news/2022/12/18/helsinko/',10,1,'2022-12-18 18:12:00+08','https://lenta.ru/news/2022/12/18/helsinko/','В посольстве рассказали о проблеме с российскими туристами в Хельсинки');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/hamuri_deport/',4,1,'2022-12-18 18:09:00+08','https://lenta.ru/news/2022/12/18/hamuri_deport/','Израиль депортировал во Францию палестинского правозащитника Салаха Хамури'),
	 ('https://lenta.ru/news/2022/12/18/hamuri_deport/',10,1,'2022-12-18 18:09:00+08','https://lenta.ru/news/2022/12/18/hamuri_deport/','Израиль депортировал во Францию палестинского правозащитника Салаха Хамури'),
	 ('https://lenta.ru/news/2022/12/18/iran_arest/',4,1,'2022-12-18 18:05:00+08','https://lenta.ru/news/2022/12/18/iran_arest/','Полиция Ирана арестовала известнейшую в стране актрису из-за протестов'),
	 ('https://lenta.ru/news/2022/12/18/iran_arest/',10,1,'2022-12-18 18:05:00+08','https://lenta.ru/news/2022/12/18/iran_arest/','Полиция Ирана арестовала известнейшую в стране актрису из-за протестов'),
	 ('https://lenta.ru/news/2022/12/18/lets_unite/',5,1,'2022-12-18 18:03:00+08','https://lenta.ru/news/2022/12/18/lets_unite/','Кадыров обратился к мусульманам на китайском и призвал объединяться против США'),
	 ('https://lenta.ru/news/2022/12/18/svyaz/',5,1,'2022-12-18 17:57:00+08','https://lenta.ru/news/2022/12/18/svyaz/','Российский боец рассказал о кодовом слове для связи с женой из зоны СВО'),
	 ('https://lenta.ru/news/2022/12/18/chel/',5,1,'2022-12-18 17:48:00+08','https://lenta.ru/news/2022/12/18/chel/','В российском ТЦ произошел пожар'),
	 ('https://lenta.ru/news/2022/12/18/norrie/',8,1,'2022-12-18 17:46:00+08','https://lenta.ru/news/2022/12/18/norrie/','Британский теннисист захотел видеть россиян на Уимблдоне'),
	 ('https://lenta.ru/news/2022/12/18/grad/',5,1,'2022-12-18 17:42:00+08','https://lenta.ru/news/2022/12/18/grad/','На Донецк за 10 минут обрушилось 40 ракет из «Града»'),
	 ('https://lenta.ru/news/2022/12/18/fifa_zelensky/',4,1,'2022-12-18 17:36:00+08','https://lenta.ru/news/2022/12/18/fifa_zelensky/','В Киеве отреагировали на отказ ФИФА показывать речь Зеленского перед финалом ЧМ');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/dilers/',9,1,'2022-12-18 17:29:00+08','https://lenta.ru/news/2022/12/18/dilers/','Россиян предупредили о подорожании новых автомобилей после Нового года'),
	 ('https://lenta.ru/news/2022/12/18/greece_2/',4,1,'2022-12-18 17:29:00+08','https://lenta.ru/news/2022/12/18/greece_2/','В Греции рассказали о масштабах поддержки Украины'),
	 ('https://lenta.ru/news/2022/12/18/greece_2/',10,1,'2022-12-18 17:29:00+08','https://lenta.ru/news/2022/12/18/greece_2/','В Греции рассказали о масштабах поддержки Украины'),
	 ('https://lenta.ru/news/2022/12/18/poteri_vsu/',5,1,'2022-12-18 17:22:00+08','https://lenta.ru/news/2022/12/18/poteri_vsu/','В ЛНР раскрыли потери ВСУ за сутки'),
	 ('https://lenta.ru/news/2022/12/18/putin_podpisal/',5,1,'2022-12-18 17:21:00+08','https://lenta.ru/news/2022/12/18/putin_podpisal/','Путин подписал закон о порядке назначения главы Счетной палаты'),
	 ('https://lenta.ru/news/2022/12/18/naz_ugroza/',4,1,'2022-12-18 17:20:00+08','https://lenta.ru/news/2022/12/18/naz_ugroza/','В США назвали поддержку Украины угрозой национальной безопасности страны'),
	 ('https://lenta.ru/news/2022/12/18/naz_ugroza/',10,1,'2022-12-18 17:20:00+08','https://lenta.ru/news/2022/12/18/naz_ugroza/','В США назвали поддержку Украины угрозой национальной безопасности страны'),
	 ('https://lenta.ru/news/2022/12/18/lovren/',8,1,'2022-12-18 17:15:00+08','https://lenta.ru/news/2022/12/18/lovren/','Хорватский футболист устроил перепалку с журналистами после завоевания бронзы ЧМ'),
	 ('https://lenta.ru/news/2022/12/18/senov/',5,1,'2022-12-18 17:12:00+08','https://lenta.ru/news/2022/12/18/senov/','Мэр Энергодара описал происходящее в городе'),
	 ('https://lenta.ru/news/2022/12/18/brimstone/',4,1,'2022-12-18 16:53:00+08','https://lenta.ru/news/2022/12/18/brimstone/','Великобритания поставила Украине новую партию высокоточных ракет Brimstone-2');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/18/brimstone/',10,1,'2022-12-18 16:53:00+08','https://lenta.ru/news/2022/12/18/brimstone/','Великобритания поставила Украине новую партию высокоточных ракет Brimstone-2'),
	 ('https://lenta.ru/news/2022/12/18/francisk/',4,1,'2022-12-18 16:49:00+08','https://lenta.ru/news/2022/12/18/francisk/','Папа Римский назвал условие своего отречения'),
	 ('https://lenta.ru/news/2022/12/18/francisk/',10,1,'2022-12-18 16:49:00+08','https://lenta.ru/news/2022/12/18/francisk/','Папа Римский назвал условие своего отречения'),
	 ('https://lenta.ru/news/2022/12/18/otklyucheniya/',4,1,'2022-12-18 16:46:00+08','https://lenta.ru/news/2022/12/18/otklyucheniya/','В трех украинских регионах ввели экстренные отключения света'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955832-minoboroni-velikobritanii',10,2,'2022-12-18 18:26:28+08','https://www.vedomosti.ru/politics/news/2022/12/18/955832-minoboroni-velikobritanii','Минобороны Великобритании сообщило о поставке Киеву ракет Brimstone 2'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955828-papa-rimskii',10,2,'2022-12-18 17:57:55+08','https://www.vedomosti.ru/politics/news/2022/12/18/955828-papa-rimskii','Папа Римский назвал конфликт на Украине мировой войной'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955827-putin',10,2,'2022-12-18 17:26:54+08','https://www.vedomosti.ru/politics/news/2022/12/18/955827-putin','Путин утвердил поправки в закон о Счетной палате'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955826-bloomberg-dogovorilis',10,2,'2022-12-18 17:10:19+08','https://www.vedomosti.ru/politics/news/2022/12/18/955826-bloomberg-dogovorilis','Bloomberg: в ЕС договорились о «крупнейшем законе о климате в Европе»'),
	 ('https://tass.ru/sport/16624165',8,3,'2022-12-18 18:26:18+08','https://tass.ru/sport/16624165','Отсутствие у РУСАДА статуса соответствия не является препятствием для восстановления ВФЛА'),
	 ('https://tass.ru/obschestvo/16624171',1,3,'2022-12-18 18:25:27+08','https://tass.ru/obschestvo/16624171','Роспотребнадзор с 19 декабря откроет горячую линию о качестве пищевых продуктов');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/kosmos/16624157',6,3,'2022-12-18 18:24:53+08','https://tass.ru/kosmos/16624157','Иран планирует запустить два спутника Nahid в ближайшее время'),
	 ('https://tass.ru/obschestvo/16624153',1,3,'2022-12-18 18:22:18+08','https://tass.ru/obschestvo/16624153','В Уганде отменили региональный карантин, введенный из-за лихорадки Эбола'),
	 ('https://tass.ru/obschestvo/16624143',1,3,'2022-12-18 18:19:31+08','https://tass.ru/obschestvo/16624143','Оба самолета с пассажирами из РФ, застрявшие в Хельсинки, прилетели в Турцию'),
	 ('https://tass.ru/obschestvo/16624125',5,3,'2022-12-18 18:16:52+08','https://tass.ru/obschestvo/16624125','В Москве в уборке снега задействовали почти 119 тыс. человек'),
	 ('https://tass.ru/obschestvo/16624053',5,3,'2022-12-18 18:08:01+08','https://tass.ru/obschestvo/16624053','В авиакомпании Pegasus подтвердили посадку самолета в Хельсинки из-за снегопада в Москве'),
	 ('https://tass.ru/ekonomika/16624035',9,3,'2022-12-18 18:05:34+08','https://tass.ru/ekonomika/16624035','Компания Prology перенесла сборку магнитол из Китая на саратовский завод "РЭМО"'),
	 ('https://tass.ru/sport/16624119',8,3,'2022-12-18 18:02:45+08','https://tass.ru/sport/16624119','Матыцин с оптимизмом смотрит на возвращение госслужащих к работе по окончании санкций CAS'),
	 ('https://tass.ru/kultura/16624093',3,3,'2022-12-18 18:00:07+08','https://tass.ru/kultura/16624093','Франдетти поставил мюзикл в Театре кукол им. Образцова'),
	 ('https://tass.ru/obschestvo/16624043',1,3,'2022-12-18 17:53:50+08','https://tass.ru/obschestvo/16624043','В Удмуртии временно ограничили движение на трех трассах'),
	 ('https://tass.ru/obschestvo/16624027',1,3,'2022-12-18 17:49:03+08','https://tass.ru/obschestvo/16624027','Школьникам РФ покажут видео про спасение бойца СВО с неразорвавшимся снарядом в груди');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/ekonomika/16624069',9,3,'2022-12-18 17:48:36+08','https://tass.ru/ekonomika/16624069','Кабмин ждет от Минпромторга и Минфина предложения по обеспечению промипотеки в 2023'),
	 ('https://tass.ru/kosmos/16624065',6,3,'2022-12-18 17:47:01+08','https://tass.ru/kosmos/16624065','В Роскосмосе сообщили о снижении температуры корабля "Союз МС-22"'),
	 ('https://tass.ru/sport/16624037',8,3,'2022-12-18 17:45:52+08','https://tass.ru/sport/16624037','Глава ВФЛА Иванов заявил, что ведет переговоры о встрече с руководством World Athletics'),
	 ('https://tass.ru/kultura/16624031',3,3,'2022-12-18 17:42:50+08','https://tass.ru/kultura/16624031','Первую часть коллекции икон Липницкого продали за 15 млн рублей'),
	 ('https://tass.ru/ekonomika/16623999',9,3,'2022-12-18 17:34:49+08','https://tass.ru/ekonomika/16623999','Президент Банка Франции заявил, что инфляция в стране достигла 7,1%'),
	 ('https://tass.ru/sport/16624007',8,3,'2022-12-18 17:32:28+08','https://tass.ru/sport/16624007','Матыцин заявил, что в любой момент может вернуться к исполнению обязанностей главы FISU'),
	 ('https://tass.ru/obschestvo/16623949',5,3,'2022-12-18 17:27:46+08','https://tass.ru/obschestvo/16623949','В РЖД сообщили, что непогода не повлияла на график пригородных поездов в Москве и области'),
	 ('https://tass.ru/ekonomika/16623983',9,3,'2022-12-18 17:25:44+08','https://tass.ru/ekonomika/16623983','Подконтрольные Киеву АЭС вышли на плановую мощность'),
	 ('https://tass.ru/obschestvo/16623967',1,3,'2022-12-18 17:23:47+08','https://tass.ru/obschestvo/16623967','В аэропорту Хельсинки не прокомментировали информацию о застрявших пассажирах из РФ'),
	 ('https://tass.ru/obschestvo/16623947',1,3,'2022-12-18 17:17:32+08','https://tass.ru/obschestvo/16623947','Старт массового перелета через Эльбрус на аэростатах перенесли из-за погодных условий');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/proisshestviya/16623961',7,3,'2022-12-18 17:16:41+08','https://tass.ru/proisshestviya/16623961','В ДНР сообщили, что ВСУ выпустили по Донецку 40 ракет из "Градов" за 10 минут'),
	 ('https://tass.ru/nedvizhimost/16623893',5,3,'2022-12-18 17:14:29+08','https://tass.ru/nedvizhimost/16623893','В центре Москвы пустуют 748 помещений, которые жители могут оформить в собственность'),
	 ('https://tass.ru/proisshestviya/16623887',7,3,'2022-12-18 17:04:56+08','https://tass.ru/proisshestviya/16623887','В Оренбуржье погибли четыре человека при столкновении легкового автомобиля и грузовика'),
	 ('https://tass.ru/proisshestviya/16623891',7,3,'2022-12-18 17:01:13+08','https://tass.ru/proisshestviya/16623891','После пожара под Воронежем, где погибли два ребенка, госпитализировали еще четырех детей'),
	 ('https://tass.ru/politika/16623909',10,3,'2022-12-18 17:00:40+08','https://tass.ru/politika/16623909','Путин подписал закон о праве Совфеда назначать главу Счетной палаты'),
	 ('https://tass.ru/proisshestviya/16623901',7,3,'2022-12-18 16:59:18+08','https://tass.ru/proisshestviya/16623901','В ДНР сообщили об обстреле из "Градов" Макеевки и Ясиноватой со стороны ВСУ'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623881',4,3,'2022-12-18 16:56:01+08','https://tass.ru/mezhdunarodnaya-panorama/16623881','Турция выступает за диалог между Египтом и Ливией по демаркации морских границ'),
	 ('https://tass.ru/sport/16623895',8,3,'2022-12-18 16:55:19+08','https://tass.ru/sport/16623895','Петр Иванов вернулся на пост президента Всероссийской федерации легкой атлетики'),
	 ('https://tass.ru/obschestvo/16623873',5,3,'2022-12-18 16:51:58+08','https://tass.ru/obschestvo/16623873','В Москве из-за сильного снегопада задерживаются автобусы и электробусы'),
	 ('https://tass.ru/obschestvo/16623869',1,3,'2022-12-18 16:48:33+08','https://tass.ru/obschestvo/16623869','Роспотребнадзор рекомендовал ввести на Алтае масочный режим в общепите и на транспорте');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/ekonomika/16623861',9,3,'2022-12-18 16:44:16+08','https://tass.ru/ekonomika/16623861','Кабмин выделил более 243 млн рублей на строительство поликлиники в Калининграде'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16623839',4,3,'2022-12-18 16:36:49+08','https://tass.ru/mezhdunarodnaya-panorama/16623839','СМИ: при взрыве в провинции Киркук погибли 10 иракских полицейских'),
	 ('https://lenta.ru/news/2022/12/19/ekvador/',7,1,'2022-12-19 20:54:27+08','https://lenta.ru/news/2022/12/19/ekvador/','Российский суд приговор эквадорца к 17 годам колонии за контрабанду наркотиков'),
	 ('https://lenta.ru/news/2022/12/19/otttv/',5,1,'2022-12-19 20:54:17+08','https://lenta.ru/news/2022/12/19/otttv/','Генерал армии ответил на слова Зеленского о возвращении Крыма'),
	 ('https://lenta.ru/news/2022/12/19/vkvstrechi/',2,1,'2022-12-19 20:53:28+08','https://lenta.ru/news/2022/12/19/vkvstrechi/','VK приготовила серию увлекательных лекций на Новый год'),
	 ('https://lenta.ru/news/2022/12/19/punkt/',5,1,'2022-12-19 20:47:00+08','https://lenta.ru/news/2022/12/19/punkt/','Группа «Викинг» уничтожила опорный пункт наемников в ДНР'),
	 ('https://lenta.ru/news/2022/12/19/zavorotnyuk_med/',3,1,'2022-12-19 20:45:38+08','https://lenta.ru/news/2022/12/19/zavorotnyuk_med/','Стало известно местонахождение борющейся с раком Анастасии Заворотнюк'),
	 ('https://lenta.ru/news/2022/12/19/eurorost/',9,1,'2022-12-19 20:44:00+08','https://lenta.ru/news/2022/12/19/eurorost/','Курс евро превысил 72 рубля'),
	 ('https://lenta.ru/news/2022/12/19/minskoutin/',4,1,'2022-12-19 20:40:00+08','https://lenta.ru/news/2022/12/19/minskoutin/','Путин прибыл в Минск на переговоры с Лукашенко'),
	 ('https://lenta.ru/news/2022/12/19/karshering/',5,1,'2022-12-19 20:38:00+08','https://lenta.ru/news/2022/12/19/karshering/','В Москве водитель каршеринга насмерть задавил пенсионерку и попал на видео');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/mortgage_plus/',1,1,'2022-12-19 20:36:00+08','https://lenta.ru/news/2022/12/19/mortgage_plus/','Названы плюсы продления льготной ипотеки'),
	 ('https://lenta.ru/news/2022/12/19/iranready/',4,1,'2022-12-19 20:33:00+08','https://lenta.ru/news/2022/12/19/iranready/','МИД Ирана обвинил Вашингтон в лицемерии и несоблюдении СВПД'),
	 ('https://lenta.ru/news/2022/12/19/iranready/',10,1,'2022-12-19 20:33:00+08','https://lenta.ru/news/2022/12/19/iranready/','МИД Ирана обвинил Вашингтон в лицемерии и несоблюдении СВПД'),
	 ('https://lenta.ru/news/2022/12/19/ukrainefifa/',8,1,'2022-12-19 20:29:58+08','https://lenta.ru/news/2022/12/19/ukrainefifa/','ФИФА и УЕФА пригрозили Украине лишением членства в организациях'),
	 ('https://lenta.ru/news/2022/12/19/ncyt/',6,1,'2022-12-19 20:27:00+08','https://lenta.ru/news/2022/12/19/ncyt/','Американского конкурента российского «Энергомаша» продали'),
	 ('https://lenta.ru/news/2022/12/19/winslet/',3,1,'2022-12-19 20:24:00+08','https://lenta.ru/news/2022/12/19/winslet/','Кейт Уинслет ответила обвинившим ее лишний вес в смерти Джека в «Титанике» людям'),
	 ('https://lenta.ru/news/2022/12/19/dobrovoltsy/',4,1,'2022-12-19 16:28:00+08','https://lenta.ru/news/2022/12/19/dobrovoltsy/','Армия Польши решила набрать добровольцев'),
	 ('https://lenta.ru/news/2022/12/19/nana_comment/',3,1,'2022-12-19 20:23:00+08','https://lenta.ru/news/2022/12/19/nana_comment/','Солист группы «На-На» прокомментировал состояние дочери в реанимации'),
	 ('https://lenta.ru/news/2022/12/19/zrk_patriot/',6,1,'2022-12-19 20:20:00+08','https://lenta.ru/news/2022/12/19/zrk_patriot/','Военный аналитик рассказал о недостатках американских ЗРК Patriot'),
	 ('https://lenta.ru/news/2022/12/19/biooo/',5,1,'2022-12-19 20:17:00+08','https://lenta.ru/news/2022/12/19/biooo/','В Госдуме назвали изменения в законопроекте о биометрии');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/metro/',7,1,'2022-12-19 20:17:00+08','https://lenta.ru/news/2022/12/19/metro/','Полковник Исаев отказался признавать вину по делу о теракте в московском метро'),
	 ('https://lenta.ru/news/2022/12/19/tours/',1,1,'2022-12-19 20:17:00+08','https://lenta.ru/news/2022/12/19/tours/','Россиянам задержат возврат средств за отмененные из-за начала СВО туры'),
	 ('https://lenta.ru/news/2022/12/19/gbr_ua/',4,1,'2022-12-19 20:15:00+08','https://lenta.ru/news/2022/12/19/gbr_ua/','На Украине завершили расследование дела о госизмене против Януковича и Азарова'),
	 ('https://lenta.ru/news/2022/12/19/nashe/',9,1,'2022-12-19 20:10:00+08','https://lenta.ru/news/2022/12/19/nashe/','Глава Минцифры рассказал о застрявших на Тайване российских процессорах'),
	 ('https://lenta.ru/news/2022/12/19/qrkod/',5,1,'2022-12-19 20:10:00+08','https://lenta.ru/news/2022/12/19/qrkod/','Роспотребнадзор заявил об отсутствии планов введения QR-кодов из-за гриппа'),
	 ('https://lenta.ru/news/2022/12/19/nagrady/',5,1,'2022-12-19 20:09:00+08','https://lenta.ru/news/2022/12/19/nagrady/','Главам ДНР и ЛНР присвоили высшую степень ордена «За заслуги перед Отечеством»'),
	 ('https://lenta.ru/news/2022/12/19/vk_results/',3,1,'2022-12-19 20:08:00+08','https://lenta.ru/news/2022/12/19/vk_results/','Назван самый популярный артист года'),
	 ('https://lenta.ru/news/2022/12/19/ussr_eu/',5,1,'2022-12-19 20:04:00+08','https://lenta.ru/news/2022/12/19/ussr_eu/','В Совфеде отреагировали на идею о воссоздании СССР по принципу ЕС'),
	 ('https://lenta.ru/news/2022/12/19/musk_uhod/',2,1,'2022-12-19 20:03:00+08','https://lenta.ru/news/2022/12/19/musk_uhod/','В Twitter проголосовали за уход Маска с поста главы платформы'),
	 ('https://lenta.ru/news/2022/12/19/vertolet_vsu/',5,1,'2022-12-19 20:03:00+08','https://lenta.ru/news/2022/12/19/vertolet_vsu/','Опубликованы кадры уничтожения вертолета ВСУ в ДНР');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/otvetpraisu/',4,1,'2022-12-19 20:02:00+08','https://lenta.ru/news/2022/12/19/otvetpraisu/','В МИД назвали условие для снижения напряженности между Россией и США'),
	 ('https://lenta.ru/news/2022/12/19/otvetpraisu/',10,1,'2022-12-19 20:02:00+08','https://lenta.ru/news/2022/12/19/otvetpraisu/','В МИД назвали условие для снижения напряженности между Россией и США'),
	 ('https://lenta.ru/news/2022/12/19/8tw9c/',6,1,'2022-12-19 20:00:00+08','https://lenta.ru/news/2022/12/19/8tw9c/','Россия в разы нарастила производство ракет «Искандер»'),
	 ('https://lenta.ru/news/2022/12/19/chm_messi/',8,1,'2022-12-19 19:59:57+08','https://lenta.ru/news/2022/12/19/chm_messi/','Стали известны подробности о черной накидке Месси на награждении победителей ЧМ'),
	 ('https://lenta.ru/news/2022/12/19/c300_greece/',4,1,'2022-12-19 19:52:00+08','https://lenta.ru/news/2022/12/19/c300_greece/','Россия пообещала уничтожить греческие C-300 на Украине'),
	 ('https://lenta.ru/news/2022/12/19/c300_greece/',10,1,'2022-12-19 19:52:00+08','https://lenta.ru/news/2022/12/19/c300_greece/','Россия пообещала уничтожить греческие C-300 на Украине'),
	 ('https://lenta.ru/news/2022/12/19/cop_deal/',1,1,'2022-12-19 19:52:00+08','https://lenta.ru/news/2022/12/19/cop_deal/','Стало известно об историческом соглашении по сохранению природы'),
	 ('https://lenta.ru/news/2022/12/19/gluhari/',5,1,'2022-12-19 19:50:14+08','https://lenta.ru/news/2022/12/19/gluhari/','В Архангельской области откроют глухариную ферму и музей'),
	 ('https://lenta.ru/news/2022/12/19/trevogaukr2/',4,1,'2022-12-19 19:50:00+08','https://lenta.ru/news/2022/12/19/trevogaukr2/','На большей части Украины объявили воздушную тревогу'),
	 ('https://lenta.ru/news/2022/12/19/peskov_sroki/',5,1,'2022-12-19 19:46:00+08','https://lenta.ru/news/2022/12/19/peskov_sroki/','Кремль переадресовал в Минобороны вопрос об изменениях сроков службы в армии');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/insomnia/',6,1,'2022-12-19 19:44:00+08','https://lenta.ru/news/2022/12/19/insomnia/','Обнаружена прямая взаимосвязь между болью в пояснице и бессонницей'),
	 ('https://lenta.ru/news/2022/12/19/mute/',1,1,'2022-12-19 19:41:00+08','https://lenta.ru/news/2022/12/19/mute/','Врач предупредила об угрозе глухоты для миллиардов людей'),
	 ('https://lenta.ru/news/2022/12/19/oproverg/',5,1,'2022-12-19 19:40:00+08','https://lenta.ru/news/2022/12/19/oproverg/','Кремль назвал глупыми сообщения о планах Путина обсудить участие Минска в СВО'),
	 ('https://lenta.ru/news/2022/12/19/nazzv/',5,1,'2022-12-19 19:39:00+08','https://lenta.ru/news/2022/12/19/nazzv/','Кремль назвал возможные темы переговоров Путина и Лукашенко'),
	 ('https://lenta.ru/news/2022/12/19/nabumagu/',9,1,'2022-12-19 19:38:00+08','https://lenta.ru/news/2022/12/19/nabumagu/','В Кремле сообщили о работе над ответом России на потолок цен на нефть'),
	 ('https://lenta.ru/news/2022/12/19/shot/',1,1,'2022-12-19 19:37:00+08','https://lenta.ru/news/2022/12/19/shot/','Водитель во время разворота случайно выстрелил себе в пах и умер'),
	 ('https://lenta.ru/news/2022/12/19/sspecoheraciya/',5,1,'2022-12-19 19:36:00+08','https://lenta.ru/news/2022/12/19/sspecoheraciya/','Военкор Куликовский раскрыл обстановку в районе Кременной в ЛНР'),
	 ('https://lenta.ru/news/2022/12/19/uralss/',5,1,'2022-12-19 19:33:00+08','https://lenta.ru/news/2022/12/19/uralss/','Россиянин вступил в ЧВК «Вагнер» для поисков брата-близнеца в зоне СВО и пропал'),
	 ('https://lenta.ru/news/2022/12/19/por/',7,1,'2022-12-19 19:30:00+08','https://lenta.ru/news/2022/12/19/por/','Двоих россиян задержали по подозрению в организации порностудий с сотрудниками'),
	 ('https://lenta.ru/news/2022/12/19/minomet/',5,1,'2022-12-19 19:28:00+08','https://lenta.ru/news/2022/12/19/minomet/','ВСУ обстреляли из минометов российскую приграничную деревню');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/svastika/',2,1,'2022-12-19 19:26:00+08','https://lenta.ru/news/2022/12/19/svastika/','В кроссворде New York Times усмотрели нацистскую символику'),
	 ('https://lenta.ru/news/2022/12/19/ski/',5,1,'2022-12-19 19:23:39+08','https://lenta.ru/news/2022/12/19/ski/','В центре Владимира открылся горнолыжный комплекс'),
	 ('https://lenta.ru/news/2022/12/19/yarushin_dom/',1,1,'2022-12-19 19:18:00+08','https://lenta.ru/news/2022/12/19/yarushin_dom/','Звезда сериала «Универ» рассказал о трудностях с постройкой дома'),
	 ('https://lenta.ru/news/2022/12/19/bpla/',6,1,'2022-12-19 19:16:00+08','https://lenta.ru/news/2022/12/19/bpla/','В России заявили о превосходстве отечественных дронов-камикадзе'),
	 ('https://lenta.ru/news/2022/12/19/energosistema/',4,1,'2022-12-19 19:14:00+08','https://lenta.ru/news/2022/12/19/energosistema/','На Украине заявили о критической ситуации в энергосистеме'),
	 ('https://lenta.ru/news/2022/12/19/germany_visas/',1,1,'2022-12-19 19:14:00+08','https://lenta.ru/news/2022/12/19/germany_visas/','В Германии назвали еще одно препятствие для выдачи виз россиянам'),
	 ('https://lenta.ru/news/2022/12/19/paral/',9,1,'2022-12-19 19:14:00+08','https://lenta.ru/news/2022/12/19/paral/','Власти России оценили объем параллельного импорта'),
	 ('https://lenta.ru/news/2022/12/19/shoygu/',4,1,'2022-12-19 19:14:00+08','https://lenta.ru/news/2022/12/19/shoygu/','Шойгу прибыл в Минск'),
	 ('https://lenta.ru/news/2022/12/19/gran_usa/',4,1,'2022-12-19 19:13:00+08','https://lenta.ru/news/2022/12/19/gran_usa/','В МИД заявили о нахождении России на грани прямого столкновения с США'),
	 ('https://lenta.ru/news/2022/12/19/gran_usa/',10,1,'2022-12-19 19:13:00+08','https://lenta.ru/news/2022/12/19/gran_usa/','В МИД заявили о нахождении России на грани прямого столкновения с США');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/vsu_dnr/',5,1,'2022-12-19 19:10:00+08','https://lenta.ru/news/2022/12/19/vsu_dnr/','Российские войска уничтожили две группы диверсантов ВСУ под Донецком'),
	 ('https://lenta.ru/news/2022/12/19/karta19_12/',5,1,'2022-12-19 19:07:00+08','https://lenta.ru/news/2022/12/19/karta19_12/','Опубликована карта боевых действий на Украине на 19 декабря'),
	 ('https://lenta.ru/news/2022/12/19/rektorkfu/',7,1,'2022-12-19 19:03:00+08','https://lenta.ru/news/2022/12/19/rektorkfu/','Ректору Казанского университета продлили арест по делу об убийстве'),
	 ('https://lenta.ru/news/2022/12/19/belorusboegotovn/',4,1,'2022-12-19 18:59:00+08','https://lenta.ru/news/2022/12/19/belorusboegotovn/','Белоруссия завершила внезапную проверку боеготовности армии'),
	 ('https://lenta.ru/news/2022/12/19/martinezobiasnenie/',8,1,'2022-12-19 18:59:00+08','https://lenta.ru/news/2022/12/19/martinezobiasnenie/','Голкипер сборной Аргентины объяснил неприличный жест во время награждения на ЧМ'),
	 ('https://lenta.ru/news/2022/12/19/putin/',5,1,'2022-12-19 18:59:00+08','https://lenta.ru/news/2022/12/19/putin/','Путин запретил суррогатное материнство для иностранцев'),
	 ('https://lenta.ru/news/2022/12/19/qercodes/',5,1,'2022-12-19 18:55:00+08','https://lenta.ru/news/2022/12/19/qercodes/','В Роспотребнадзоре оценили необходимость введения ограничений из-за гриппа'),
	 ('https://lenta.ru/news/2022/12/19/politico_ua/',4,1,'2022-12-19 18:54:00+08','https://lenta.ru/news/2022/12/19/politico_ua/','Журналисты сравнили терпение ЕС и США в отношении поддержки Украины'),
	 ('https://lenta.ru/news/2022/12/19/prosiba/',4,1,'2022-12-19 18:54:00+08','https://lenta.ru/news/2022/12/19/prosiba/','Зеленский попросил у западных лидеров еще больше оружия'),
	 ('https://lenta.ru/news/2022/12/19/ukforcesreservists/',4,1,'2022-12-19 18:52:00+08','https://lenta.ru/news/2022/12/19/ukforcesreservists/','В Великобритании из-за забастовок захотели мобилизовать резервистов');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/ukforcesreservists/',10,1,'2022-12-19 18:52:00+08','https://lenta.ru/news/2022/12/19/ukforcesreservists/','В Великобритании из-за забастовок захотели мобилизовать резервистов'),
	 ('https://lenta.ru/news/2022/12/19/prigozhin_pushkarev/',2,1,'2022-12-19 18:51:00+08','https://lenta.ru/news/2022/12/19/prigozhin_pushkarev/','Пригожин обвинил экс-журналиста Znak.com в работе на ЦРУ'),
	 ('https://lenta.ru/news/2022/12/19/ie/',6,1,'2022-12-19 18:50:00+08','https://lenta.ru/news/2022/12/19/ie/','Названа окончательная «дата смерти» Internet Explorer'),
	 ('https://lenta.ru/news/2022/12/19/austria_ru_spy/',4,1,'2022-12-19 18:43:00+08','https://lenta.ru/news/2022/12/19/austria_ru_spy/','В Австрии подтвердили расследование против российского шпиона из Греции'),
	 ('https://lenta.ru/news/2022/12/19/austria_ru_spy/',10,1,'2022-12-19 18:43:00+08','https://lenta.ru/news/2022/12/19/austria_ru_spy/','В Австрии подтвердили расследование против российского шпиона из Греции'),
	 ('https://lenta.ru/news/2022/12/19/minn/',5,1,'2022-12-19 18:43:00+08','https://lenta.ru/news/2022/12/19/minn/','ВС России уничтожили четыре диверсионные группы ВСУ в ЛНР'),
	 ('https://lenta.ru/news/2022/12/19/gzzz/',9,1,'2022-12-19 18:37:00+08','https://lenta.ru/news/2022/12/19/gzzz/','Описаны лучший и худший сценарии отопительного сезона в Европе'),
	 ('https://lenta.ru/news/2022/12/19/record_estate/',1,1,'2022-12-19 18:37:00+08','https://lenta.ru/news/2022/12/19/record_estate/','В Москве выставили на продажу рекордное число новых квартир'),
	 ('https://lenta.ru/news/2022/12/19/ataki/',5,1,'2022-12-19 18:36:00+08','https://lenta.ru/news/2022/12/19/ataki/','Минобороны отчиталось о занятии выгодных рубежей на донецком направлении'),
	 ('https://lenta.ru/news/2022/12/19/hungary_potolok/',4,1,'2022-12-19 18:36:00+08','https://lenta.ru/news/2022/12/19/hungary_potolok/','В Венгрии назвали вредным и опасным введение потолка цен на российский газ');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/hungary_potolok/',10,1,'2022-12-19 18:36:00+08','https://lenta.ru/news/2022/12/19/hungary_potolok/','В Венгрии назвали вредным и опасным введение потолка цен на российский газ'),
	 ('https://lenta.ru/news/2022/12/19/ronaldo/',8,1,'2022-12-19 18:35:08+08','https://lenta.ru/news/2022/12/19/ronaldo/','Анчелотти оценил возможный трансфер Роналду в саудовский клуб'),
	 ('https://lenta.ru/news/2022/12/19/myau/',9,1,'2022-12-19 18:35:00+08','https://lenta.ru/news/2022/12/19/myau/','В России резко выросли цены на корма для домашних животных'),
	 ('https://lenta.ru/news/2022/12/19/severdv/',7,1,'2022-12-19 18:35:00+08','https://lenta.ru/news/2022/12/19/severdv/','В ЛНР попытались ввезти елочные игрушки с призывами убивать русских'),
	 ('https://lenta.ru/news/2022/12/19/games/',9,1,'2022-12-19 18:34:00+08','https://lenta.ru/news/2022/12/19/games/','В России задумались о подконтрольном государству разработчике видеоигр'),
	 ('https://lenta.ru/news/2022/12/19/putin_zaes/',5,1,'2022-12-19 18:34:00+08','https://lenta.ru/news/2022/12/19/putin_zaes/','Путин отменил наказание за негрубые нарушения в сфере атома на Запорожье'),
	 ('https://lenta.ru/news/2022/12/19/pereeh/',5,1,'2022-12-19 18:32:00+08','https://lenta.ru/news/2022/12/19/pereeh/','ВС России сбили восемь украинских беспилотников'),
	 ('https://lenta.ru/news/2022/12/19/harm/',5,1,'2022-12-19 18:31:00+08','https://lenta.ru/news/2022/12/19/harm/','В приграничном российском регионе системы ПВО сбили четыре ракеты HARM'),
	 ('https://lenta.ru/news/2022/12/19/obstrek/',5,1,'2022-12-19 18:31:00+08','https://lenta.ru/news/2022/12/19/obstrek/','Приграничный российский регион третий раз за день обстреляли со стороны Украины'),
	 ('https://lenta.ru/news/2022/12/19/minnno/',5,1,'2022-12-19 18:30:00+08','https://lenta.ru/news/2022/12/19/minnno/','Минобороны рассказало о поражении пунктов временной дислокации ВСУ');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/korp/',5,1,'2022-12-19 18:27:00+08','https://lenta.ru/news/2022/12/19/korp/','Россиян предупредили об опасности новогодних корпоративов'),
	 ('https://lenta.ru/news/2022/12/19/delo_gbr/',4,1,'2022-12-19 18:26:00+08','https://lenta.ru/news/2022/12/19/delo_gbr/','Названо число возбужденных на Украине дел о коллаборационизме с начала СВО'),
	 ('https://lenta.ru/news/2022/12/19/torg/',4,1,'2022-12-19 18:23:00+08','https://lenta.ru/news/2022/12/19/torg/','В Еврокомиссии предложили усилить борьбу с торговцами людьми'),
	 ('https://lenta.ru/news/2022/12/19/torg/',10,1,'2022-12-19 18:23:00+08','https://lenta.ru/news/2022/12/19/torg/','В Еврокомиссии предложили усилить борьбу с торговцами людьми'),
	 ('https://lenta.ru/news/2022/12/19/flashscenes/',3,1,'2022-12-19 18:22:00+08','https://lenta.ru/news/2022/12/19/flashscenes/','Из «Флэша» вырежут камео Супермена и Чудо-женщины с Кавиллом и Гадот'),
	 ('https://lenta.ru/news/2022/12/19/soyuzz/',6,1,'2022-12-19 18:22:00+08','https://lenta.ru/news/2022/12/19/soyuzz/','Установлено точное место повреждения «Союза МС-22»'),
	 ('https://lenta.ru/news/2022/12/19/gz/',9,1,'2022-12-19 18:20:00+08','https://lenta.ru/news/2022/12/19/gz/','Названы тревожные особенности отопительного сезона в Европе'),
	 ('https://lenta.ru/news/2022/12/19/meri/',5,1,'2022-12-19 18:17:00+08','https://lenta.ru/news/2022/12/19/meri/','Россиянам рассказали о методах защиты от гриппа'),
	 ('https://lenta.ru/news/2022/12/19/napalll/',7,1,'2022-12-19 18:17:00+08','https://lenta.ru/news/2022/12/19/napalll/','Установлена личность напавшего на замглавы департамента ЖКХ Москвы'),
	 ('https://lenta.ru/news/2022/12/19/gaz/',9,1,'2022-12-19 18:16:00+08','https://lenta.ru/news/2022/12/19/gaz/','Цены на газ в Европе резко снизились');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/hodakovskiy/',5,1,'2022-12-19 18:13:00+08','https://lenta.ru/news/2022/12/19/hodakovskiy/','В России предложили создать комитет по контролю действий разведки и связи'),
	 ('https://lenta.ru/news/2022/12/19/tury/',1,1,'2022-12-19 18:02:00+08','https://lenta.ru/news/2022/12/19/tury/','Альянс турагентств дал рекомендации не успевшим купить новогодние туры россиянам'),
	 ('https://lenta.ru/news/2022/12/19/core/',6,1,'2022-12-19 18:01:00+08','https://lenta.ru/news/2022/12/19/core/','Доказано существование разрывов в ядрах красных гигантов'),
	 ('https://lenta.ru/news/2022/12/19/riot_juccy/',4,1,'2022-12-19 17:53:00+08','https://lenta.ru/news/2022/12/19/riot_juccy/','В МИД прокомментировали задержание Pussy Riot в Катаре'),
	 ('https://lenta.ru/news/2022/12/19/riot_juccy/',10,1,'2022-12-19 17:53:00+08','https://lenta.ru/news/2022/12/19/riot_juccy/','В МИД прокомментировали задержание Pussy Riot в Катаре'),
	 ('https://lenta.ru/news/2022/12/19/cxron/',5,1,'2022-12-19 17:52:00+08','https://lenta.ru/news/2022/12/19/cxron/','Кадыров показал кадры обнаружения схрона с натовским оружием'),
	 ('https://lenta.ru/news/2022/12/19/drake_mil/',3,1,'2022-12-19 17:52:00+08','https://lenta.ru/news/2022/12/19/drake_mil/','Дрейк сделал ставку на победу Аргентины в финале ЧМ и проиграл миллион долларов'),
	 ('https://lenta.ru/news/2022/12/19/nanacont/',3,1,'2022-12-19 17:52:00+08','https://lenta.ru/news/2022/12/19/nanacont/','Дочь солиста группы «На-На» пришла в себя после госпитализации'),
	 ('https://lenta.ru/news/2022/12/19/postradavshie/',5,1,'2022-12-19 17:47:00+08','https://lenta.ru/news/2022/12/19/postradavshie/','Число пострадавших при обрушении строительных лесов в Подмосковье увеличилось'),
	 ('https://lenta.ru/news/2022/12/19/kiev_svet/',4,1,'2022-12-19 17:37:00+08','https://lenta.ru/news/2022/12/19/kiev_svet/','Несколько районов Киева отключили от электроснабжения из-за обстрелов');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/france_championnat/',4,1,'2022-12-19 17:36:00+08','https://lenta.ru/news/2022/12/19/france_championnat/','Во Франции сотни человек задержали в ходе беспорядков после финала ЧМ'),
	 ('https://lenta.ru/news/2022/12/19/france_championnat/',10,1,'2022-12-19 17:36:00+08','https://lenta.ru/news/2022/12/19/france_championnat/','Во Франции сотни человек задержали в ходе беспорядков после финала ЧМ'),
	 ('https://lenta.ru/news/2022/12/19/fotovystavka/',5,1,'2022-12-19 17:35:54+08','https://lenta.ru/news/2022/12/19/fotovystavka/','В Махачкале открылась фотовыставка объектов культурного наследия Дагестана'),
	 ('https://lenta.ru/news/2022/12/19/podderzhka/',4,1,'2022-12-19 17:33:00+08','https://lenta.ru/news/2022/12/19/podderzhka/','В Польше назвали общую сумму поддержки Украины'),
	 ('https://lenta.ru/news/2022/12/19/podderzhka/',10,1,'2022-12-19 17:33:00+08','https://lenta.ru/news/2022/12/19/podderzhka/','В Польше назвали общую сумму поддержки Украины'),
	 ('https://lenta.ru/news/2022/12/19/mincifry/',2,1,'2022-12-19 17:30:00+08','https://lenta.ru/news/2022/12/19/mincifry/','Глава Минцифры оценил популярность VPN-сервисов в России'),
	 ('https://lenta.ru/news/2022/12/19/prigozhin/',5,1,'2022-12-19 17:30:00+08','https://lenta.ru/news/2022/12/19/prigozhin/','Пригожин обратился в Госдуму из-за отказа хоронить вагнеровца с почестями'),
	 ('https://lenta.ru/news/2022/12/19/quatar_estate/',1,1,'2022-12-19 17:30:00+08','https://lenta.ru/news/2022/12/19/quatar_estate/','Катару предсказали проблемы после чемпионата мира'),
	 ('https://lenta.ru/news/2022/12/19/potolok/',9,1,'2022-12-19 17:26:00+08','https://lenta.ru/news/2022/12/19/potolok/','В Европе назвали новое предложение по потолку цен на газ'),
	 ('https://lenta.ru/news/2022/12/19/marathon/',6,1,'2022-12-19 17:24:00+08','https://lenta.ru/news/2022/12/19/marathon/','«Роскосмос» раскрыл подробности об аналоге Starlink');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/gibel/',5,1,'2022-12-19 17:23:00+08','https://lenta.ru/news/2022/12/19/gibel/','Появились подробности гибели 14-летнего подростка в Екатеринбурге'),
	 ('https://lenta.ru/news/2022/12/19/lequipe/',8,1,'2022-12-19 17:22:56+08','https://lenta.ru/news/2022/12/19/lequipe/','Названа символическая сборная чемпионата мира'),
	 ('https://lenta.ru/news/2022/12/19/girdano_died/',3,1,'2022-12-19 17:21:00+08','https://lenta.ru/news/2022/12/19/girdano_died/','Умерла «Мисс Италия» и актриса фильма «1001 ночь» Даниэла Джордано'),
	 ('https://lenta.ru/news/2022/12/19/khabar/',7,1,'2022-12-19 17:14:00+08','https://lenta.ru/news/2022/12/19/khabar/','Раскрыты детали расследования смертельного ДТП с автобусом в Хабаровском крае'),
	 ('https://lenta.ru/news/2022/12/19/serbia_passports/',1,1,'2022-12-19 17:10:00+08','https://lenta.ru/news/2022/12/19/serbia_passports/','Европейская страна пообещала выдать россиянам гражданство в ускоренном режиме'),
	 ('https://lenta.ru/news/2022/12/19/obstrel/',5,1,'2022-12-19 17:09:00+08','https://lenta.ru/news/2022/12/19/obstrel/','Приграничный российский регион обстреляли со стороны Украины'),
	 ('https://lenta.ru/news/2022/12/19/sitiy_evac/',4,1,'2022-12-19 17:05:00+08','https://lenta.ru/news/2022/12/19/sitiy_evac/','Главу «Русского дома» в ЦАР эвакуируют в Россию для лечения'),
	 ('https://lenta.ru/news/2022/12/19/sitiy_evac/',10,1,'2022-12-19 17:05:00+08','https://lenta.ru/news/2022/12/19/sitiy_evac/','Главу «Русского дома» в ЦАР эвакуируют в Россию для лечения'),
	 ('https://lenta.ru/news/2022/12/19/forget/',1,1,'2022-12-19 17:01:00+08','https://lenta.ru/news/2022/12/19/forget/','Мужчина зарезал незнакомца и забыл об этом'),
	 ('https://lenta.ru/news/2022/12/19/stambul_russia/',1,1,'2022-12-19 17:01:00+08','https://lenta.ru/news/2022/12/19/stambul_russia/','Названы самые популярные районы Стамбула у москвичей');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/loss/',2,1,'2022-12-19 16:59:00+08','https://lenta.ru/news/2022/12/19/loss/','В США констатировали невозможность скрывать правду о потерях ВСУ'),
	 ('https://lenta.ru/news/2022/12/19/mrot/',9,1,'2022-12-19 16:59:00+08','https://lenta.ru/news/2022/12/19/mrot/','Путин подписал закон о повышении МРОТ'),
	 ('https://lenta.ru/news/2022/12/19/kulemzin/',5,1,'2022-12-19 16:55:00+08','https://lenta.ru/news/2022/12/19/kulemzin/','В Донецке под обстрел попало здание администрации'),
	 ('https://lenta.ru/news/2022/12/19/sbor_avatar/',3,1,'2022-12-19 16:55:00+08','https://lenta.ru/news/2022/12/19/sbor_avatar/','«Аватар: Путь воды» заработал 435 миллионов долларов в прокате за первый уик-энд'),
	 ('https://lenta.ru/news/2022/12/19/pamyatka/',1,1,'2022-12-19 16:54:00+08','https://lenta.ru/news/2022/12/19/pamyatka/','Перед Новым годом туристам составили памятку на случай задержки рейсов'),
	 ('https://lenta.ru/news/2022/12/19/dirty_green_papers/',9,1,'2022-12-19 16:52:00+08','https://lenta.ru/news/2022/12/19/dirty_green_papers/','Курс доллара превысил 66 рублей'),
	 ('https://lenta.ru/news/2022/12/19/izbili/',5,1,'2022-12-19 16:47:00+08','https://lenta.ru/news/2022/12/19/izbili/','Московские школьницы толпой избили 13-летнюю девочку'),
	 ('https://lenta.ru/news/2022/12/19/trevogaukr/',4,1,'2022-12-19 16:43:00+08','https://lenta.ru/news/2022/12/19/trevogaukr/','На востоке Украины объявили воздушную тревогу'),
	 ('https://lenta.ru/news/2022/12/19/lesa/',5,1,'2022-12-19 16:37:00+08','https://lenta.ru/news/2022/12/19/lesa/','Десять человек пострадали при обрушении строительных лесов в Подмосковье'),
	 ('https://lenta.ru/news/2022/12/19/novogod/',9,1,'2022-12-19 16:37:00+08','https://lenta.ru/news/2022/12/19/novogod/','Траты россиян на продукты для новогоднего стола резко выросли');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/verni/',9,1,'2022-12-19 16:36:00+08','https://lenta.ru/news/2022/12/19/verni/','Российский покупатель Airbus захотел вернуть свой аванс'),
	 ('https://lenta.ru/news/2022/12/19/krs/',9,1,'2022-12-19 16:35:00+08','https://lenta.ru/news/2022/12/19/krs/','Экономист описал будущее курса доллара'),
	 ('https://lenta.ru/news/2022/12/19/rosgvardd/',7,1,'2022-12-19 16:27:00+08','https://lenta.ru/news/2022/12/19/rosgvardd/','Командир взвода войсковой части Росгвардии совершил суицид в общежитии'),
	 ('https://lenta.ru/news/2022/12/19/systemss/',5,1,'2022-12-19 16:27:00+08','https://lenta.ru/news/2022/12/19/systemss/','В Белгородской области заявили о неэффективности системы оповещения об обстрелах'),
	 ('https://lenta.ru/news/2022/12/19/miguel_chbd/',2,1,'2022-12-19 16:26:00+08','https://lenta.ru/news/2022/12/19/miguel_chbd/','Звезда ТНТ рассказал о стыде от съемок в «Что было дальше?»'),
	 ('https://lenta.ru/news/2022/12/19/eur/',9,1,'2022-12-19 16:21:00+08','https://lenta.ru/news/2022/12/19/eur/','Курс евро превысил 70 рублей'),
	 ('https://lenta.ru/news/2022/12/19/silur/',5,1,'2022-12-19 16:21:00+08','https://lenta.ru/news/2022/12/19/silur/','ВСУ обстреляли крупный сталепроволочный завод в ДНР'),
	 ('https://lenta.ru/news/2022/12/19/ottepel/',1,1,'2022-12-19 16:16:00+08','https://lenta.ru/news/2022/12/19/ottepel/','Москвичам предрекли оттепель'),
	 ('https://lenta.ru/news/2022/12/19/mongolia/',1,1,'2022-12-19 16:15:00+08','https://lenta.ru/news/2022/12/19/mongolia/','Популярная азиатская страна начала завлекать россиян скидками в торговых центрах'),
	 ('https://lenta.ru/news/2022/12/19/evrosouz/',4,1,'2022-12-19 16:14:00+08','https://lenta.ru/news/2022/12/19/evrosouz/','В ЦАР сгорели здания делегации ЕС');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/evrosouz/',10,1,'2022-12-19 16:14:00+08','https://lenta.ru/news/2022/12/19/evrosouz/','В ЦАР сгорели здания делегации ЕС'),
	 ('https://lenta.ru/news/2022/12/19/covid/',5,1,'2022-12-19 16:06:00+08','https://lenta.ru/news/2022/12/19/covid/','В России выявили 6341 случай коронавируса'),
	 ('https://lenta.ru/news/2022/12/19/volodinss/',5,1,'2022-12-19 16:04:00+08','https://lenta.ru/news/2022/12/19/volodinss/','Володин порассуждал о погибших бойцах ЧВК «Вагнер»'),
	 ('https://lenta.ru/news/2022/12/19/animalsarethebest/',1,1,'2022-12-19 16:02:00+08','https://lenta.ru/news/2022/12/19/animalsarethebest/','Женщина бросила работу визажистки ради коров и кур и не пожалела'),
	 ('https://lenta.ru/news/2022/12/19/fsbvid/',7,1,'2022-12-19 16:01:00+08','https://lenta.ru/news/2022/12/19/fsbvid/','Задержание ФСБ передававшего секретные данные Украине россиянина попало на видео'),
	 ('https://lenta.ru/news/2022/12/19/tombulov/',7,1,'2022-12-19 15:52:00+08','https://lenta.ru/news/2022/12/19/tombulov/','Бывшему прокурору подмосковного Раменского запросили 20 лет за взятки'),
	 ('https://lenta.ru/news/2022/12/19/bulanova/',1,1,'2022-12-19 15:51:00+08','https://lenta.ru/news/2022/12/19/bulanova/','Татьяна Буланова раскритиковала жизнь за городом'),
	 ('https://lenta.ru/news/2022/12/19/kievklichko/',4,1,'2022-12-19 15:51:00+08','https://lenta.ru/news/2022/12/19/kievklichko/','Кличко сообщил о повреждении инфраструктуры Киева'),
	 ('https://lenta.ru/news/2022/12/19/kaprizov/',8,1,'2022-12-19 15:50:00+08','https://lenta.ru/news/2022/12/19/kaprizov/','Капризова признали первой звездой дня в НХЛ'),
	 ('https://lenta.ru/news/2022/12/19/vertolet/',5,1,'2022-12-19 15:49:00+08','https://lenta.ru/news/2022/12/19/vertolet/','Появились кадры с места аварийной посадки вертолета в Магаданской области');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/tarantino_adam/',3,1,'2022-12-19 15:45:00+08','https://lenta.ru/news/2022/12/19/tarantino_adam/','Тарантино подтвердил написание роли в «Бесславных ублюдках» для Адама Сэндлера'),
	 ('https://lenta.ru/news/2022/12/19/tu160m/',6,1,'2022-12-19 15:37:00+08','https://lenta.ru/news/2022/12/19/tu160m/','Очередной модернизированный Ту-160М поднялся в воздух'),
	 ('https://lenta.ru/news/2022/12/19/sevasss/',7,1,'2022-12-19 15:36:00+08','https://lenta.ru/news/2022/12/19/sevasss/','ФСБ сообщила о приговоре россиянину за госизмену в пользу Украины'),
	 ('https://lenta.ru/news/2022/12/19/ice/',1,1,'2022-12-19 15:32:00+08','https://lenta.ru/news/2022/12/19/ice/','Тиктокерша придумала необычный способ избежать падения на льду'),
	 ('https://lenta.ru/news/2022/12/19/avtobus/',5,1,'2022-12-19 15:31:00+08','https://lenta.ru/news/2022/12/19/avtobus/','На российской дороге перевернулся школьный автобус'),
	 ('https://lenta.ru/news/2022/12/19/mariyinka/',5,1,'2022-12-19 15:30:00+08','https://lenta.ru/news/2022/12/19/mariyinka/','Пушилин сообщил о зачистке центра Марьинки от ВСУ'),
	 ('https://lenta.ru/news/2022/12/19/estonia/',1,1,'2022-12-19 15:29:00+08','https://lenta.ru/news/2022/12/19/estonia/','Стало известно о временном закрытии границы с популярной европейской страной'),
	 ('https://lenta.ru/news/2022/12/19/china_russia/',4,1,'2022-12-19 15:27:00+08','https://lenta.ru/news/2022/12/19/china_russia/','Россия и Китай проведут совместные морские учения'),
	 ('https://lenta.ru/news/2022/12/19/china_russia/',10,1,'2022-12-19 15:27:00+08','https://lenta.ru/news/2022/12/19/china_russia/','Россия и Китай проведут совместные морские учения'),
	 ('https://lenta.ru/news/2022/12/19/drop/',9,1,'2022-12-19 15:24:34+08','https://lenta.ru/news/2022/12/19/drop/','В Сбере рассказали о стратегии «Антидроп»');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/spain_animals/',1,1,'2022-12-19 15:24:00+08','https://lenta.ru/news/2022/12/19/spain_animals/','Переехавшая в Барселону россиянка рассказала об отношении испанцев к животным'),
	 ('https://lenta.ru/news/2022/12/19/uzly_vsu/',5,1,'2022-12-19 15:24:00+08','https://lenta.ru/news/2022/12/19/uzly_vsu/','Удар российского «Тюльпана» минами до 230 килограммов попал на видео'),
	 ('https://lenta.ru/news/2022/12/19/tehnik/',7,1,'2022-12-19 15:21:00+08','https://lenta.ru/news/2022/12/19/tehnik/','В подмосковной воинской части произошло убийство'),
	 ('https://lenta.ru/news/2022/12/19/decadence/',9,1,'2022-12-19 15:16:00+08','https://lenta.ru/news/2022/12/19/decadence/','В России стали массово закрываться кафе и рестораны'),
	 ('https://lenta.ru/news/2022/12/19/otravleniee/',5,1,'2022-12-19 15:16:00+08','https://lenta.ru/news/2022/12/19/otravleniee/','Четверо россиян насмерть отравились угарным газом'),
	 ('https://lenta.ru/news/2022/12/19/antybiotikss/',5,1,'2022-12-19 15:15:00+08','https://lenta.ru/news/2022/12/19/antybiotikss/','В российских аптеках резко вырос спрос на редкий антибиотик'),
	 ('https://lenta.ru/news/2022/12/19/rosgvsuu/',7,1,'2022-12-19 15:13:00+08','https://lenta.ru/news/2022/12/19/rosgvsuu/','Росгвардейцы выявили 24 пособника ВСУ под Херсоном и в Запорожье'),
	 ('https://lenta.ru/news/2022/12/19/8939587/',4,1,'2022-12-19 15:08:00+08','https://lenta.ru/news/2022/12/19/8939587/','В Катаре задержали участников Pussy Riot'),
	 ('https://lenta.ru/news/2022/12/19/8939587/',10,1,'2022-12-19 15:08:00+08','https://lenta.ru/news/2022/12/19/8939587/','В Катаре задержали участников Pussy Riot'),
	 ('https://lenta.ru/news/2022/12/19/croc/',1,1,'2022-12-19 15:03:00+08','https://lenta.ru/news/2022/12/19/croc/','Крокодил утащил собаку в реку на глазах у хозяев');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/sgorel/',5,1,'2022-12-19 14:57:00+08','https://lenta.ru/news/2022/12/19/sgorel/','В российском регионе вертолет опрокинулся при посадке и сгорел'),
	 ('https://lenta.ru/news/2022/12/19/whatsapp/',2,1,'2022-12-19 14:56:00+08','https://lenta.ru/news/2022/12/19/whatsapp/','Пользователям WhatsApp станет доступна новая возможность'),
	 ('https://lenta.ru/news/2022/12/19/open_trailer/',3,1,'2022-12-19 14:55:00+08','https://lenta.ru/news/2022/12/19/open_trailer/','Вышел первый официальный трейлер фильма «Оппенгеймер» Кристофера Нолана'),
	 ('https://lenta.ru/news/2022/12/19/don_razb/',5,1,'2022-12-19 14:54:00+08','https://lenta.ru/news/2022/12/19/don_razb/','В ДНР заявили об уничтожении части позиций ВСУ'),
	 ('https://lenta.ru/news/2022/12/19/chinaspg/',9,1,'2022-12-19 14:50:00+08','https://lenta.ru/news/2022/12/19/chinaspg/','Китай рекордно закупил один вид топлива'),
	 ('https://lenta.ru/news/2022/12/19/kievkissinger/',4,1,'2022-12-19 14:47:00+08','https://lenta.ru/news/2022/12/19/kievkissinger/','В Киеве возразили Киссинджеру в вопросе переговоров с Россией'),
	 ('https://lenta.ru/news/2022/12/19/sochi_spros/',1,1,'2022-12-19 14:47:00+08','https://lenta.ru/news/2022/12/19/sochi_spros/','Россияне расхотели покупать новостройки в Сочи'),
	 ('https://lenta.ru/news/2022/12/19/regions/',5,1,'2022-12-19 14:45:00+08','https://lenta.ru/news/2022/12/19/regions/','Вильфанд спрогнозировал опасную погоду в некоторых регионах России'),
	 ('https://lenta.ru/news/2022/12/19/delooo/',7,1,'2022-12-19 14:44:00+08','https://lenta.ru/news/2022/12/19/delooo/','Начато расследование из-за пожара на газовом месторождении в Иркутской области'),
	 ('https://lenta.ru/news/2022/12/19/politov_reason/',3,1,'2022-12-19 14:41:00+08','https://lenta.ru/news/2022/12/19/politov_reason/','Стала известна причина госпитализации дочери солиста группы «На-На»');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/biden_visit/',4,1,'2022-12-19 14:37:00+08','https://lenta.ru/news/2022/12/19/biden_visit/','В Белом доме назвали причину отказа Байдена посещать Украину'),
	 ('https://lenta.ru/news/2022/12/19/biden_visit/',10,1,'2022-12-19 14:37:00+08','https://lenta.ru/news/2022/12/19/biden_visit/','В Белом доме назвали причину отказа Байдена посещать Украину'),
	 ('https://lenta.ru/news/2022/12/19/prokurat/',7,1,'2022-12-19 14:37:00+08','https://lenta.ru/news/2022/12/19/prokurat/','Прокуратура признала законным возбуждение дела в отношении троих сотрудников МВД'),
	 ('https://lenta.ru/news/2022/12/19/vsrf/',2,1,'2022-12-19 14:35:00+08','https://lenta.ru/news/2022/12/19/vsrf/','В Хорватии назвали приоритетную цель ВС России на Украине'),
	 ('https://lenta.ru/news/2022/12/19/aksenovss/',5,1,'2022-12-19 14:32:00+08','https://lenta.ru/news/2022/12/19/aksenovss/','Аксенов оценил заполняемость водохранилищ в Крыму'),
	 ('https://lenta.ru/news/2022/12/19/kids_orvi/',1,1,'2022-12-19 14:32:00+08','https://lenta.ru/news/2022/12/19/kids_orvi/','Врач назвал опасные действия родителей при лечении ОРВИ у ребенка'),
	 ('https://lenta.ru/news/2022/12/19/avia/',1,1,'2022-12-19 14:27:00+08','https://lenta.ru/news/2022/12/19/avia/','Почти 60 рейсов отменили и задержали в аэропортах Москвы'),
	 ('https://lenta.ru/news/2022/12/19/hua/',9,1,'2022-12-19 14:25:00+08','https://lenta.ru/news/2022/12/19/hua/','Huawei закроет одно из российских подразделений'),
	 ('https://lenta.ru/news/2022/12/19/panarinkravtsov/',8,1,'2022-12-19 14:22:00+08','https://lenta.ru/news/2022/12/19/panarinkravtsov/','Шестеркин повторил достижение «Рейнджерс» 90-летней давности в НХЛ'),
	 ('https://lenta.ru/news/2022/12/19/korna_spigun/',4,1,'2022-12-19 14:14:00+08','https://lenta.ru/news/2022/12/19/korna_spigun/','Австрия задержала гражданина Греции по обвинению в шпионаже в пользу России');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://lenta.ru/news/2022/12/19/korna_spigun/',10,1,'2022-12-19 14:14:00+08','https://lenta.ru/news/2022/12/19/korna_spigun/','Австрия задержала гражданина Греции по обвинению в шпионаже в пользу России'),
	 ('https://lenta.ru/news/2022/12/19/smoothies/',1,1,'2022-12-19 14:11:00+08','https://lenta.ru/news/2022/12/19/smoothies/','Диетолог назвала четыре рецепта смузи для похудения'),
	 ('https://lenta.ru/news/2022/12/19/obshezhit/',7,1,'2022-12-19 14:09:00+08','https://lenta.ru/news/2022/12/19/obshezhit/','Четверо россиян предстали перед судом за избиение до смерти жильцов общежития'),
	 ('https://lenta.ru/news/2022/12/19/siamskyzaliv/',4,1,'2022-12-19 14:07:00+08','https://lenta.ru/news/2022/12/19/siamskyzaliv/','Военный корабль Таиланда с сотней пехотинцев на борту перевернулся и затонул'),
	 ('https://lenta.ru/news/2022/12/19/siamskyzaliv/',10,1,'2022-12-19 14:07:00+08','https://lenta.ru/news/2022/12/19/siamskyzaliv/','Военный корабль Таиланда с сотней пехотинцев на борту перевернулся и затонул'),
	 ('https://lenta.ru/news/2022/12/19/aero_rus/',1,1,'2022-12-19 14:06:00+08','https://lenta.ru/news/2022/12/19/aero_rus/','В России в очередной раз продлили ограничения на полеты на юге страны'),
	 ('https://lenta.ru/news/2022/12/19/mask/',8,1,'2022-12-19 14:06:00+08','https://lenta.ru/news/2022/12/19/mask/','Маск посмеялся над кризисом во Франции «из-за России» во время ЧМ'),
	 ('https://www.vedomosti.ru/business/news/2022/12/19/955981-vlasti-ne-soglasovali-prodazhu-rossiiskogo-biznesa-mondi',9,2,'2022-12-19 20:55:53+08','https://www.vedomosti.ru/business/news/2022/12/19/955981-vlasti-ne-soglasovali-prodazhu-rossiiskogo-biznesa-mondi','РБК: власти не согласовали продажу российского бизнеса Mondi в Сыктывкаре'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955974-v-kurskoi-soobschili-ob-obstrele',1,2,'2022-12-19 20:55:20+08','https://www.vedomosti.ru/society/news/2022/12/19/955974-v-kurskoi-soobschili-ob-obstrele','В Курской области сообщили об обстреле села в Глушковском районе'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955979-putin-pribil-s-v-minsk',10,2,'2022-12-19 20:51:05+08','https://www.vedomosti.ru/politics/news/2022/12/19/955979-putin-pribil-s-v-minsk','Путин прибыл с визитом в Минск');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955972-peskov-sroki-vihoda-ukaza',10,2,'2022-12-19 20:26:39+08','https://www.vedomosti.ru/politics/news/2022/12/19/955972-peskov-sroki-vihoda-ukaza','Песков назвал сроки выхода указа об ответных мерах на потолок цен на нефть'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955967-putin-20-dekabrya-vruchit-gosudarstvennie-nagradi-pasechniku-i-pushilinu',10,2,'2022-12-19 20:23:21+08','https://www.vedomosti.ru/politics/news/2022/12/19/955967-putin-20-dekabrya-vruchit-gosudarstvennie-nagradi-pasechniku-i-pushilinu','Путин 20 декабря вручит государственные награды Пасечнику и Пушилину'),
	 ('https://www.vedomosti.ru/media/news/2022/12/19/955963-bolshinstvo-polzovatelei-twitter-progolosovali-za-uhod-maska',9,2,'2022-12-19 20:13:22+08','https://www.vedomosti.ru/media/news/2022/12/19/955963-bolshinstvo-polzovatelei-twitter-progolosovali-za-uhod-maska','Большинство пользователей Twitter проголосовали за уход Маска с поста главы компании'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955966-peskov-oproverg-soobscheniya-ob-obsuzhdenii-uchastiya-belorussii',10,2,'2022-12-19 20:12:18+08','https://www.vedomosti.ru/politics/news/2022/12/19/955966-peskov-oproverg-soobscheniya-ob-obsuzhdenii-uchastiya-belorussii','Песков опроверг сообщения об обсуждении участия Белоруссии в СВО'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955960-mid-nazval-vrazhdebnimi-plan-postavok-afinami-ukraine-zrk',10,2,'2022-12-19 19:56:28+08','https://www.vedomosti.ru/politics/news/2022/12/19/955960-mid-nazval-vrazhdebnimi-plan-postavok-afinami-ukraine-zrk','МИД назвал враждебным план поставок Афинами Украине ЗРК С-300'),
	 ('https://www.vedomosti.ru/auto/news/2022/12/19/955951-glava-fts-soobschil-o-naraschivanii',6,2,'2022-12-19 19:27:05+08','https://www.vedomosti.ru/auto/news/2022/12/19/955951-glava-fts-soobschil-o-naraschivanii','Глава ФТС рассказал о наращивании поставок китайский автомобилей в Россию'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/19/955952-v-rostehe-soobschili-o-roste',9,2,'2022-12-19 19:21:26+08','https://www.vedomosti.ru/economics/news/2022/12/19/955952-v-rostehe-soobschili-o-roste','В «Ростехе» сообщили о росте производства ОТРК «Искандер» и боеприпасов к ним'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955955-v-rossii-ne-planiruyut-qr-kodi',1,2,'2022-12-19 19:13:02+08','https://www.vedomosti.ru/society/news/2022/12/19/955955-v-rossii-ne-planiruyut-qr-kodi','В России не планируют вводить QR-коды из-за заболеваемости гриппом и ОРВИ'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955953-zakon-o-zaprete-uslug-surrogatnih-materei',1,2,'2022-12-19 19:02:31+08','https://www.vedomosti.ru/society/news/2022/12/19/955953-zakon-o-zaprete-uslug-surrogatnih-materei','Путин подписал закон о запрете услуг суррогатных матерей для иностранцев'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955950-belgorodskoi-oblasti-obstrele',10,2,'2022-12-19 18:50:12+08','https://www.vedomosti.ru/politics/news/2022/12/19/955950-belgorodskoi-oblasti-obstrele','В Белгородской области сообщили об обстреле хутора Панкова');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955949-minoboroni-soobschilo-o-perehvate-amerikanskih-raket',10,2,'2022-12-19 18:40:12+08','https://www.vedomosti.ru/politics/news/2022/12/19/955949-minoboroni-soobschilo-o-perehvate-amerikanskih-raket','Минобороны сообщило о перехвате американских ракет над Белгородской областью'),
	 ('https://www.vedomosti.ru/finance/news/2022/12/19/955938-vtb-soobschil-o-zapuske-transgranichnih-perevodov',9,2,'2022-12-19 18:35:55+08','https://www.vedomosti.ru/finance/news/2022/12/19/955938-vtb-soobschil-o-zapuske-transgranichnih-perevodov','ВТБ сообщил о запуске трансграничных переводов в Иран'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955941-pamyatnik-ministru-zinichevu',1,2,'2022-12-19 18:27:41+08','https://www.vedomosti.ru/society/news/2022/12/19/955941-pamyatnik-ministru-zinichevu','Памятник погибшему руководителю МЧС Зиничеву планируют открыть в конце декабря'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/19/955944-mintsifri-oprovergli-soobscheniya-ob-utechke-dannih-gosuslug',6,2,'2022-12-19 18:27:18+08','https://www.vedomosti.ru/technology/news/2022/12/19/955944-mintsifri-oprovergli-soobscheniya-ob-utechke-dannih-gosuslug','В Минцифры опровергли сообщения об утечке данных «Госуслуг»'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/19/955934-v-minekonomrazvitiya-utochnili-otsenku-padeniya-vvp',9,2,'2022-12-19 17:59:05+08','https://www.vedomosti.ru/economics/news/2022/12/19/955934-v-minekonomrazvitiya-utochnili-otsenku-padeniya-vvp','В Минэкономразвития уточнили оценку падения ВВП за десять месяцев'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/19/955937-v-roskosmose-ustanovili-mesto-utechki',1,2,'2022-12-19 17:56:01+08','https://www.vedomosti.ru/technology/news/2022/12/19/955937-v-roskosmose-ustanovili-mesto-utechki','«РИА Новости»: в «Роскосмосе» установили место утечки в «Союзе МС-22»'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955933-belgorodskoi-oblasti-bez-sveta',10,2,'2022-12-19 17:34:18+08','https://www.vedomosti.ru/politics/news/2022/12/19/955933-belgorodskoi-oblasti-bez-sveta','В Белгородской области 14 000 жителей остались без света после обстрела ВСУ'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955931-glavu-russkogo-doma-ekstrenno-evakuiruyut',1,2,'2022-12-19 17:19:32+08','https://www.vedomosti.ru/society/news/2022/12/19/955931-glavu-russkogo-doma-ekstrenno-evakuiruyut','Главу «Русского дома» экстренно эвакуируют после покушения в Россию'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955924-volodin-prizval-ne-razdelyat-pogibshih-voennosluzhaschih',1,2,'2022-12-19 17:16:05+08','https://www.vedomosti.ru/society/news/2022/12/19/955924-volodin-prizval-ne-razdelyat-pogibshih-voennosluzhaschih','Володин призвал не разделять погибших военнослужащих и бойцов ЧВК'),
	 ('https://www.vedomosti.ru/technology/news/2022/12/19/955928-vpn-servisi-v-rossii-ne-prizhivayutsya',6,2,'2022-12-19 17:11:40+08','https://www.vedomosti.ru/technology/news/2022/12/19/955928-vpn-servisi-v-rossii-ne-prizhivayutsya','Глава Минцифры заявил, что VPN-сервисы в России «не приживаются»');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955912-zhitelya-sevastopolya-prigovorili-k-12-godam',1,2,'2022-12-19 17:08:37+08','https://www.vedomosti.ru/society/news/2022/12/19/955912-zhitelya-sevastopolya-prigovorili-k-12-godam','Жителя Севастополя приговорили к 12 годам колонии по делу о госизмене'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955929-gladkov-sistem-opovescheniya',10,2,'2022-12-19 17:01:08+08','https://www.vedomosti.ru/politics/news/2022/12/19/955929-gladkov-sistem-opovescheniya','Белгородский губернатор заявил о неэффективности систем оповещения об обстрелах в регионе'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955927-zakon-o-ob-ustanovlenii-mrot',1,2,'2022-12-19 16:52:59+08','https://www.vedomosti.ru/society/news/2022/12/19/955927-zakon-o-ob-ustanovlenii-mrot','Путин подписал закон о повышении МРОТ до 16 242 рублей'),
	 ('https://www.vedomosti.ru/business/news/2022/12/19/955922-kuhnya-na-raione-soobschila-o-zapuske-seti-avtomatov',9,2,'2022-12-19 16:40:44+08','https://www.vedomosti.ru/business/news/2022/12/19/955922-kuhnya-na-raione-soobschila-o-zapuske-seti-avtomatov','«Кухня на районе» сообщила о запуске сети автоматов с готовой едой'),
	 ('https://www.vedomosti.ru/finance/news/2022/12/19/955923-kurs-evro',9,2,'2022-12-19 16:38:46+08','https://www.vedomosti.ru/finance/news/2022/12/19/955923-kurs-evro','Курс евро на Мосбирже впервые с мая превысил 70 рублей'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955916-golikova-o-podache-zayavleniya-na-posobie',1,2,'2022-12-19 16:21:21+08','https://www.vedomosti.ru/society/news/2022/12/19/955916-golikova-o-podache-zayavleniya-na-posobie','Голикова рассказала о правилах подачи заявления на пособие для семей с низкими доходами'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955918-ugolovnoe-delo-pozhare-markovskom-mestorozhdenii',1,2,'2022-12-19 16:19:31+08','https://www.vedomosti.ru/society/news/2022/12/19/955918-ugolovnoe-delo-pozhare-markovskom-mestorozhdenii','СК возбудил уголовное дело о пожаре на Марковском месторождении в Иркутской области'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955911-rossiya-i-kitai-provedut-sovmestnie-ucheniya',10,2,'2022-12-19 16:09:07+08','https://www.vedomosti.ru/politics/news/2022/12/19/955911-rossiya-i-kitai-provedut-sovmestnie-ucheniya','Россия и Китай проведут совместные учения в Восточно-Китайском море'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955908-v-katare-zaderzhali-uchastnikov-pussy-riot',10,2,'2022-12-19 15:54:33+08','https://www.vedomosti.ru/politics/news/2022/12/19/955908-v-katare-zaderzhali-uchastnikov-pussy-riot','В Катаре задержали участников Pussy Riot при попытке акции во время ЧМ-2022'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955906-pushilin-donetsku',10,2,'2022-12-19 15:47:36+08','https://www.vedomosti.ru/politics/news/2022/12/19/955906-pushilin-donetsku','Пушилин сообщил об уничтожении части позиций ВСУ');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955905-rbk-uznal-o-rezko-vozrosshem-sprose-na-antibiotik',1,2,'2022-12-19 15:46:41+08','https://www.vedomosti.ru/society/news/2022/12/19/955905-rbk-uznal-o-rezko-vozrosshem-sprose-na-antibiotik','РБК узнал о резко возросшем спросе на антибиотик для лечения пневмонии'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955899-v-avstrii-zaderzhali-grazhdanina-gretsii-po-podozreniyu',10,2,'2022-12-19 15:45:54+08','https://www.vedomosti.ru/politics/news/2022/12/19/955899-v-avstrii-zaderzhali-grazhdanina-gretsii-po-podozreniyu','В Австрии задержали гражданина Греции по подозрению в шпионаже в пользу России'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955904-v-magadanskoi-oblasti-razbilsya-vertolet',1,2,'2022-12-19 15:34:19+08','https://www.vedomosti.ru/society/news/2022/12/19/955904-v-magadanskoi-oblasti-razbilsya-vertolet','В Магаданской области разбился вертолет Ми-8Т'),
	 ('https://www.vedomosti.ru/auto/news/2022/12/19/955902-o-roste-tsen-na-tehosmotr',6,2,'2022-12-19 15:20:16+08','https://www.vedomosti.ru/auto/news/2022/12/19/955902-o-roste-tsen-na-tehosmotr','«Коммерсантъ» сообщил о росте цен на техосмотр авто на 57% с начала года'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955900-mide-degradatsiyu-rinkov',10,2,'2022-12-19 15:18:01+08','https://www.vedomosti.ru/politics/news/2022/12/19/955900-mide-degradatsiyu-rinkov','В МИДе предрекли деградацию рынков из-за потолка цен на газ'),
	 ('https://www.vedomosti.ru/media/news/2022/12/19/955898-mask-sprosil-polzovatelei-twitter',2,2,'2022-12-19 15:14:20+08','https://www.vedomosti.ru/media/news/2022/12/19/955898-mask-sprosil-polzovatelei-twitter','Маск спросил пользователей Twitter, стоит ли ему продолжать возглавлять компанию'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955896-tailande-zatonul-korvet',1,2,'2022-12-19 14:57:51+08','https://www.vedomosti.ru/society/news/2022/12/19/955896-tailande-zatonul-korvet','В Таиланде затонул корвет «Сукхотай»'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955892-politico-v-belom-dome-opasayutsya-zamedleniya-pomoschi-kievu',10,2,'2022-12-19 14:44:14+08','https://www.vedomosti.ru/politics/news/2022/12/19/955892-politico-v-belom-dome-opasayutsya-zamedleniya-pomoschi-kievu','Politico: в Белом доме опасаются замедления помощи Киеву со стороны Конгресса'),
	 ('https://www.vedomosti.ru/business/news/2022/12/19/955894-kommersant-videlit-50-mlrd-rublei-industrii-videoigr',9,2,'2022-12-19 14:40:17+08','https://www.vedomosti.ru/business/news/2022/12/19/955894-kommersant-videlit-50-mlrd-rublei-industrii-videoigr','Кабмин может выделить 50 млрд рублей на поддержку индустрии видеоигр'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955893-rosaviatsiya-prodlila-rezhim-ogranicheniya-poletov',1,2,'2022-12-19 14:37:36+08','https://www.vedomosti.ru/society/news/2022/12/19/955893-rosaviatsiya-prodlila-rezhim-ogranicheniya-poletov','Росавиация продлила режим ограничения полетов до 27 декабря');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955891-ob-izmeneniyah-zakonoproekta-o-biometrii',1,2,'2022-12-19 14:33:56+08','https://www.vedomosti.ru/society/news/2022/12/19/955891-ob-izmeneniyah-zakonoproekta-o-biometrii','Володин выступил против сбора биометрии россиян без их согласия'),
	 ('https://www.vedomosti.ru/business/news/2022/12/19/955889-o-zakritii-huawei',9,2,'2022-12-19 13:59:56+08','https://www.vedomosti.ru/business/news/2022/12/19/955889-o-zakritii-huawei','«Коммерсантъ» узнал о закрытии корпоративного подразделения Huawei в России'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955887-o-batalonnih-ucheniyah-v-belorussii',10,2,'2022-12-19 13:31:00+08','https://www.vedomosti.ru/politics/news/2022/12/19/955887-o-batalonnih-ucheniyah-v-belorussii','Минобороны сообщило о батальонных учениях в Белоруссии'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/19/955886-v-kieve-soobschili-o-vzrivah',10,2,'2022-12-19 13:04:26+08','https://www.vedomosti.ru/politics/news/2022/12/19/955886-v-kieve-soobschili-o-vzrivah','В Киеве сообщили о взрывах в городе и области'),
	 ('https://www.vedomosti.ru/business/news/2022/12/19/955885-kommersant-magazini-loccitane-v-rossii-mogut-snova-pereimenovat',9,2,'2022-12-19 12:42:54+08','https://www.vedomosti.ru/business/news/2022/12/19/955885-kommersant-magazini-loccitane-v-rossii-mogut-snova-pereimenovat','«Коммерсантъ»: магазины L’Occitane в России могут снова переименовать'),
	 ('https://www.vedomosti.ru/society/news/2022/12/19/955884-sem-chelovek-postradali-pri-pozhare-na-markovskom-mestorozhdenii',1,2,'2022-12-19 12:27:18+08','https://www.vedomosti.ru/society/news/2022/12/19/955884-sem-chelovek-postradali-pri-pozhare-na-markovskom-mestorozhdenii','Семь человек пострадали при пожаре на Марковском месторождении в Приангарье'),
	 ('https://www.vedomosti.ru/society/news/2022/12/18/955877-pozhar-markovskom-mestorozhdenii-lokalizovan',1,2,'2022-12-19 03:14:20+08','https://www.vedomosti.ru/society/news/2022/12/18/955877-pozhar-markovskom-mestorozhdenii-lokalizovan','Пожар на Марковском месторождении в Иркутской области локализован'),
	 ('https://www.vedomosti.ru/economics/news/2022/12/18/955876-poteri-evropi-energonositeli-trln',9,2,'2022-12-19 02:28:39+08','https://www.vedomosti.ru/economics/news/2022/12/18/955876-poteri-evropi-energonositeli-trln','Bloomberg: потери Европы от роста цен на энергоносители составили $1 трлн'),
	 ('https://www.vedomosti.ru/society/news/2022/12/18/955859-chelovek-postradal-pozhare-irkutskoi',1,2,'2022-12-19 01:16:40+08','https://www.vedomosti.ru/society/news/2022/12/18/955859-chelovek-postradal-pozhare-irkutskoi','Один человек пострадал при пожаре на Марковском месторождении в Иркутской области'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955856-putin-rossiya-sdelat-mir-spravedlivim',10,2,'2022-12-18 23:47:53+08','https://www.vedomosti.ru/politics/news/2022/12/18/955856-putin-rossiya-sdelat-mir-spravedlivim','Путин: Россия своими делами может сделать мир более справедливым');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955854-ministr-yustitsii',10,2,'2022-12-18 22:59:06+08','https://www.vedomosti.ru/politics/news/2022/12/18/955854-ministr-yustitsii','Министр юстиции Молдавии объяснил меры против русскоязычных телеканалов'),
	 ('https://www.vedomosti.ru/society/news/2022/12/18/955848-medinskii-uchebnik-istorii-rabochuyu',1,2,'2022-12-18 22:16:48+08','https://www.vedomosti.ru/society/news/2022/12/18/955848-medinskii-uchebnik-istorii-rabochuyu','Мединский возглавит рабочую группу по созданию нового учебника по истории'),
	 ('https://www.vedomosti.ru/society/news/2022/12/18/955849-tez-tour',1,2,'2022-12-18 22:14:14+08','https://www.vedomosti.ru/society/news/2022/12/18/955849-tez-tour','Tez Tour уточнил сроки возвращения застрявших в Египте туристов'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955847-saldo-stroit',10,2,'2022-12-18 21:52:05+08','https://www.vedomosti.ru/politics/news/2022/12/18/955847-saldo-stroit','Сальдо: строить новый город в Херсонской области будут под контролем Кириенко'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955845-shvetsii-proizvedut',10,2,'2022-12-18 21:26:01+08','https://www.vedomosti.ru/politics/news/2022/12/18/955845-shvetsii-proizvedut','В Швеции произведут новые замеры на месте подрыва «Северных потоков»'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955843-kontrol-rossiiskih-voennih-yakovlevka',10,2,'2022-12-18 20:43:48+08','https://www.vedomosti.ru/politics/news/2022/12/18/955843-kontrol-rossiiskih-voennih-yakovlevka','Минобороны РФ: под контроль российских военных перешла Яковлевка в ДНР'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955841-zaharova',10,2,'2022-12-18 20:40:57+08','https://www.vedomosti.ru/politics/news/2022/12/18/955841-zaharova','Захарова сравнила обострение в Косово с войной в Грузии'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955839-ispanii',10,2,'2022-12-18 20:03:29+08','https://www.vedomosti.ru/politics/news/2022/12/18/955839-ispanii','ТАСС: в Испании перехвачено подозрительное письмо, направленное консульству Украины'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955838-belgorodskom-obstrela-pogib-chelovek',10,2,'2022-12-18 19:49:33+08','https://www.vedomosti.ru/politics/news/2022/12/18/955838-belgorodskom-obstrela-pogib-chelovek','Губернатор Белгородской области сообщил об одном погибшем после срабатывания ПВО'),
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955835-kadirov',10,2,'2022-12-18 19:32:19+08','https://www.vedomosti.ru/politics/news/2022/12/18/955835-kadirov','Кадыров на китайском языке призвал исламский мир объединиться против НАТО');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://www.vedomosti.ru/politics/news/2022/12/18/955834-belgorodom-srabotala-pvo',10,2,'2022-12-18 19:08:03+08','https://www.vedomosti.ru/politics/news/2022/12/18/955834-belgorodom-srabotala-pvo','Над Белгородом сработала система ПВО'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16632099',4,3,'2022-12-19 20:56:49+08','https://tass.ru/mezhdunarodnaya-panorama/16632099','На Украине отменили воздушную тревогу'),
	 ('https://tass.ru/ekonomika/16632171',9,3,'2022-12-19 20:55:27+08','https://tass.ru/ekonomika/16632171','В МЭР сообщили о возвращении из Египта более 1 тыс. российских туристов'),
	 ('https://tass.ru/obschestvo/16632069',1,3,'2022-12-19 20:54:49+08','https://tass.ru/obschestvo/16632069','Орешкин поручил найти финансовые инструменты для обновления исторического центра Читы'),
	 ('https://tass.ru/kultura/16631321',3,3,'2022-12-19 20:54:02+08','https://tass.ru/kultura/16631321','По романам Антона Чижа про Агату Керн снимут полнометражный фильм'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16632057',4,3,'2022-12-19 20:52:39+08','https://tass.ru/mezhdunarodnaya-panorama/16632057','DPA: Бундесвер отказался от новых закупок БМП Puma до устранения неисправностей'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16631363',4,3,'2022-12-19 20:52:25+08','https://tass.ru/mezhdunarodnaya-panorama/16631363','Премьер Сербии разочарована позицией международного сообщества по Косову и Метохии'),
	 ('https://tass.ru/sport/16632123',8,3,'2022-12-19 20:52:09+08','https://tass.ru/sport/16632123','Свищев считает, что президент МОК Бах не может ассоциироваться со всем спортом'),
	 ('https://tass.ru/ekonomika/16632063',9,3,'2022-12-19 20:51:14+08','https://tass.ru/ekonomika/16632063','В Омской области запустили две газораспределительные станции'),
	 ('https://tass.ru/kultura/16631421',3,3,'2022-12-19 20:50:24+08','https://tass.ru/kultura/16631421','Созданное при поддержке РОСИЗО тревел-шоу "Музейные маршруты" вышло на Premier');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/mezhdunarodnaya-panorama/16631993',4,3,'2022-12-19 20:49:57+08','https://tass.ru/mezhdunarodnaya-panorama/16631993','Reuters: Запад не рассматривает военный вариант решения ядерной проблемы Ирана'),
	 ('https://tass.ru/ekonomika/16631399',9,3,'2022-12-19 20:48:56+08','https://tass.ru/ekonomika/16631399','Гана приостановила часть выплат по внешнему долгу'),
	 ('https://tass.ru/ekonomika/16632095',9,3,'2022-12-19 20:48:54+08','https://tass.ru/ekonomika/16632095','Ростовский губернатор поручил завершить уборку урожая до конца года'),
	 ('https://tass.ru/sport/16632083',8,3,'2022-12-19 20:48:51+08','https://tass.ru/sport/16632083','В "Крыльях Советов" назвали условия перехода Пиняева и Глушенкова в другой клуб'),
	 ('https://tass.ru/ekonomika/16631989',9,3,'2022-12-19 20:47:14+08','https://tass.ru/ekonomika/16631989','Контейнерный рынок России в ноябре 2022 года снизился на 13,5%'),
	 ('https://tass.ru/proisshestviya/16630893',7,3,'2022-12-19 20:45:14+08','https://tass.ru/proisshestviya/16630893','Напавший на филиал Банка Грузии  получил десять лет заключения'),
	 ('https://tass.ru/ekonomika/16631977',9,3,'2022-12-19 20:44:54+08','https://tass.ru/ekonomika/16631977','Уральский завод до конца года освоит выпуск отечественной листовой обшивки самолетов'),
	 ('https://tass.ru/ekonomika/16632009',9,3,'2022-12-19 20:44:13+08','https://tass.ru/ekonomika/16632009','Инкерманский завод марочных вин в Севастополе будет приватизирован'),
	 ('https://tass.ru/obschestvo/16632039',1,3,'2022-12-19 20:44:13+08','https://tass.ru/obschestvo/16632039','Участники съезда Российского движения детей и молодежи выбрали название "Движение первых"'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16632015',4,3,'2022-12-19 20:43:43+08','https://tass.ru/mezhdunarodnaya-panorama/16632015','МИД Венгрии: потолок цен на газ не будет вынуждать согласовывать изменения контрактов с РФ');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/obschestvo/16630901',1,3,'2022-12-19 20:42:45+08','https://tass.ru/obschestvo/16630901','Все запрещенные в Молдавии телеканалы подают в суд и договариваются о совместных действиях'),
	 ('https://tass.ru/obschestvo/16631791',1,3,'2022-12-19 20:42:34+08','https://tass.ru/obschestvo/16631791','Суд подтвердил картельный сговор при закупке медоборудования в Омской области в 2020 году'),
	 ('https://tass.ru/proisshestviya/16631477',7,3,'2022-12-19 20:41:24+08','https://tass.ru/proisshestviya/16631477','В половине областей Украины объявлена воздушная тревога'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16631963',4,3,'2022-12-19 20:41:10+08','https://tass.ru/mezhdunarodnaya-panorama/16631963','СМИ: делегация МАГАТЭ обсудила в Тегеране вопросы будущего сотрудничества'),
	 ('https://tass.ru/proisshestviya/16631969',7,3,'2022-12-19 20:40:53+08','https://tass.ru/proisshestviya/16631969','В Красногорске эвакуировали 65 человек из-за пожара в магазине на первом этаже жилого дома'),
	 ('https://tass.ru/obschestvo/16631935',1,3,'2022-12-19 20:40:22+08','https://tass.ru/obschestvo/16631935','В Финляндии не рекомендуют вводить запрет на покупку недвижимости россиянами'),
	 ('https://tass.ru/sport/16631951',8,3,'2022-12-19 20:39:05+08','https://tass.ru/sport/16631951','Презентация книги о столичном хоккейном клубе "Динамо" прошла в Москве'),
	 ('https://tass.ru/ekonomika/16630465',9,3,'2022-12-19 20:38:30+08','https://tass.ru/ekonomika/16630465','Глава регулятора ФРГ заявил, что надежды на снижение цен на газ в обозримом будущем мало'),
	 ('https://tass.ru/obschestvo/16631943',1,3,'2022-12-19 20:37:57+08','https://tass.ru/obschestvo/16631943','Фундамент дворца царевича Алексея в Рождествено станет частью музея Набокова в Ленобласти'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16631883',4,3,'2022-12-19 20:37:50+08','https://tass.ru/mezhdunarodnaya-panorama/16631883','Молдавский парламентарий анонсировал новые санкции в отношении оппозиционных СМИ');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/ekonomika/16631865',9,3,'2022-12-19 20:37:35+08','https://tass.ru/ekonomika/16631865','В ПСБ считают, что передача ему центробанков ЛНР и ДНР разовьет там банковскую систему'),
	 ('https://tass.ru/obschestvo/16631891',1,3,'2022-12-19 20:36:28+08','https://tass.ru/obschestvo/16631891','В Петербурге более 13% школьников болеют гриппом или ОРВИ'),
	 ('https://tass.ru/politika/16631905',10,3,'2022-12-19 20:35:56+08','https://tass.ru/politika/16631905','Путин прибыл в Белоруссию'),
	 ('https://tass.ru/proisshestviya/16630387',7,3,'2022-12-19 20:34:40+08','https://tass.ru/proisshestviya/16630387','Суд выделил в отдельное производство дело погибшего националиста Марцинкевича'),
	 ('https://tass.ru/kosmos/16631859',6,3,'2022-12-19 20:34:18+08','https://tass.ru/kosmos/16631859','Ситуация с повреждением радиатора "Союза МС-22" не отразилась на экипаже МКС'),
	 ('https://tass.ru/kosmos/16631853',6,3,'2022-12-19 20:34:10+08','https://tass.ru/kosmos/16631853','В Роскосмосе заявили, что специалисты считают резервным корабль "Союз МС-23"'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16630321',4,3,'2022-12-19 20:32:51+08','https://tass.ru/mezhdunarodnaya-panorama/16630321','Польша намерена разместить Patriot от ФРГ в Люблинском воеводстве на границе с Украиной'),
	 ('https://tass.ru/kosmos/16631877',6,3,'2022-12-19 20:32:31+08','https://tass.ru/kosmos/16631877','Комиссия решит, можно ли использовать "Союз МС-22" для возвращения космонавтов на Землю'),
	 ('https://tass.ru/kosmos/16631829',6,3,'2022-12-19 20:31:53+08','https://tass.ru/kosmos/16631829','Роскосмос заявил о стабилизации температуры в корабле "Союз МС-22" на уровне + 30 градусов'),
	 ('https://tass.ru/ekonomika/16631803',9,3,'2022-12-19 20:30:12+08','https://tass.ru/ekonomika/16631803','ЦБ ищет возможность для использования криптовалюты в международных платежах');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/ekonomika/16630127',9,3,'2022-12-19 20:30:02+08','https://tass.ru/ekonomika/16630127','Глава регулятора ФРГ не исключает ухудшения ситуации с запасами газа'),
	 ('https://tass.ru/opinions/16616505',4,3,'2022-12-19 20:30:01+08','https://tass.ru/opinions/16616505','Вновь выборы? Почему болгарские политики не в состоянии договориться о новом правительстве'),
	 ('https://tass.ru/ekonomika/16631765',9,3,'2022-12-19 20:28:56+08','https://tass.ru/ekonomika/16631765','ЦБ планирует постепенно возвращаться к уменьшению валютных ограничений'),
	 ('https://tass.ru/proisshestviya/16631759',7,3,'2022-12-19 20:28:46+08','https://tass.ru/proisshestviya/16631759','Суд ужесточил приговор по делу закладчиков наркотиков, ранивших полицейских в Кургане'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16631771',4,3,'2022-12-19 20:28:16+08','https://tass.ru/mezhdunarodnaya-panorama/16631771','В Минобороны Украины не планируют после Нового года проводить новую волну мобилизации'),
	 ('https://tass.ru/ekonomika/16631599',9,3,'2022-12-19 20:27:57+08','https://tass.ru/ekonomika/16631599','Evraz получил согласие держателей евробондов на изменение условий выпуска'),
	 ('https://tass.ru/obschestvo/16631587',1,3,'2022-12-19 20:27:48+08','https://tass.ru/obschestvo/16631587','На Северо-Западе России морозы продержатся до середины недели'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16630097',4,3,'2022-12-19 20:27:38+08','https://tass.ru/mezhdunarodnaya-panorama/16630097','Таджикистан и Евросоюз обсудили расширение сотрудничества'),
	 ('https://tass.ru/sport/16631733',8,3,'2022-12-19 20:27:33+08','https://tass.ru/sport/16631733','"Спартак" подписал контракт с трехкратным обладателем Кубка Гагарина Емелиным'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16629757',4,3,'2022-12-19 20:26:39+08','https://tass.ru/mezhdunarodnaya-panorama/16629757','Машины МККК свободно проехали по дороге в Карабахе, где протестуют азербайджанские экологи');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/obschestvo/16631567',1,3,'2022-12-19 20:24:53+08','https://tass.ru/obschestvo/16631567','За три года квота целевого приема по программам ординатуры в медвузах РФ выросла на 37%'),
	 ('https://tass.ru/obschestvo/16631701',1,3,'2022-12-19 20:24:52+08','https://tass.ru/obschestvo/16631701','В Тульской области в 3,7 раза превышен эпидпорог по ОРВИ и гриппу среди взрослых'),
	 ('https://tass.ru/ekonomika/16629729',9,3,'2022-12-19 20:24:44+08','https://tass.ru/ekonomika/16629729','Пушилин раскритиковал темпы выплат компенсаций за утраченное в результате боев имущество'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16631503',4,3,'2022-12-19 20:22:43+08','https://tass.ru/mezhdunarodnaya-panorama/16631503','В Сербии заявили, что миссии НАТО и ЕС не выполняют свои функции по защите сербов в Косове'),
	 ('https://tass.ru/ekonomika/16629645',9,3,'2022-12-19 20:22:03+08','https://tass.ru/ekonomika/16629645','Оптовая цена на мойву в центральной части России за неделю снизилась на 4,8%'),
	 ('https://tass.ru/obschestvo/16631565',1,3,'2022-12-19 20:21:54+08','https://tass.ru/obschestvo/16631565','В городе Чунцин разрешили больным COVID-19 выходить на работу'),
	 ('https://tass.ru/proisshestviya/16631623',7,3,'2022-12-19 20:20:26+08','https://tass.ru/proisshestviya/16631623','Свыше 1,9 тыс. домов Чувашии остаются без электричества из-за непогоды'),
	 ('https://tass.ru/ekonomika/16631579',9,3,'2022-12-19 20:17:47+08','https://tass.ru/ekonomika/16631579','В России появился цифровой профиль предпринимателя'),
	 ('https://tass.ru/ekonomika/16631601',9,3,'2022-12-19 20:17:09+08','https://tass.ru/ekonomika/16631601','Путин и Лукашенко обсудят газовые вопросы'),
	 ('https://tass.ru/kultura/16631571',3,3,'2022-12-19 20:15:56+08','https://tass.ru/kultura/16631571','В Петербурге на выставке к юбилею Каверина впервые представят личные вещи писателя');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/ekonomika/16631553',9,3,'2022-12-19 20:15:09+08','https://tass.ru/ekonomika/16631553','Корпорация МСП увеличит лизинговую поддержку бизнеса к 2025 году в пять раз'),
	 ('https://tass.ru/ekonomika/16631513',5,3,'2022-12-19 20:13:06+08','https://tass.ru/ekonomika/16631513','Москва стала куратором цифровой трансформации строительной отрасли в 14 регионах РФ'),
	 ('https://tass.ru/kultura/16631507',3,3,'2022-12-19 20:08:49+08','https://tass.ru/kultura/16631507','Новый фильм Мещаниновой вошел в программу Международного кинофестиваля в Роттердаме'),
	 ('https://tass.ru/ekonomika/16631393',9,3,'2022-12-19 20:07:34+08','https://tass.ru/ekonomika/16631393','В Саратовской области урожай зерна вырос в 2022 году почти вдвое'),
	 ('https://tass.ru/sport/16631515',8,3,'2022-12-19 20:06:46+08','https://tass.ru/sport/16631515','Кафанов оценил игру вратарей сборных Франции и Аргентины в финале чемпионата мира в Катаре'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16631405',4,3,'2022-12-19 20:04:47+08','https://tass.ru/mezhdunarodnaya-panorama/16631405','ФРГ выдала в октябре-ноябре более 600 нацвиз россиянам и продолжает их выдачу'),
	 ('https://tass.ru/proisshestviya/16631425',7,3,'2022-12-19 20:04:08+08','https://tass.ru/proisshestviya/16631425','Суд назначил семь лет колонии дочери экс-мэра Самары по делу о вымогательстве'),
	 ('https://tass.ru/obschestvo/16631485',1,3,'2022-12-19 20:03:02+08','https://tass.ru/obschestvo/16631485','Кабмин поручил ввезти в Россию партию американского лекарства от оспы обезьян'),
	 ('https://tass.ru/obschestvo/16631491',1,3,'2022-12-19 20:01:52+08','https://tass.ru/obschestvo/16631491','Путин 20 декабря вручит госнаграды в Кремле, в том числе Пушилину и Пасечнику'),
	 ('https://tass.ru/proisshestviya/16631331',7,3,'2022-12-19 20:01:08+08','https://tass.ru/proisshestviya/16631331','Полиция ЦАР начала расследование причин пожара в представительстве ЕС');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/sport/16631457',8,3,'2022-12-19 20:00:02+08','https://tass.ru/sport/16631457','ЦСКА обменял олимпийского чемпиона хоккеиста Киселевича в "Авангард"'),
	 ('https://tass.ru/interviews/16630425',1,3,'2022-12-19 20:00:00+08','https://tass.ru/interviews/16630425','Ректор ТУСУРа: с момента основания мы ориентированы на разработку перспективных технологий'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16631371',4,3,'2022-12-19 20:00:00+08','https://tass.ru/mezhdunarodnaya-panorama/16631371','На Украине завершили расследование против Януковича по делу Харьковских соглашений'),
	 ('https://tass.ru/sport/16631431',8,3,'2022-12-19 19:58:52+08','https://tass.ru/sport/16631431','ФИФА и УЕФА предупредили Украинскую ассоциацию футбола о возможном лишении членства'),
	 ('https://tass.ru/ekonomika/16631339',9,3,'2022-12-19 19:57:05+08','https://tass.ru/ekonomika/16631339','Три российских оператора заключили контракты на поставку базовых станций на 100 млрд руб.'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16631353',4,3,'2022-12-19 19:55:33+08','https://tass.ru/mezhdunarodnaya-panorama/16631353','Посольство США в Кишиневе получило подозрительный пакет'),
	 ('https://tass.ru/nedvizhimost/16631345',9,3,'2022-12-19 19:55:25+08','https://tass.ru/nedvizhimost/16631345','Путин подписал закон, совершенствующий защиту прав участников долевого строительства'),
	 ('https://tass.ru/politika/16631295',10,3,'2022-12-19 19:54:03+08','https://tass.ru/politika/16631295','Заседание совета Парламентского собрания России и Белоруссии пройдет в феврале'),
	 ('https://tass.ru/ekonomika/16631233',9,3,'2022-12-19 19:53:25+08','https://tass.ru/ekonomika/16631233','Газ в Европе торгуется ниже отметки в $1 200 за 1 тыс. куб. м'),
	 ('https://tass.ru/nacionalnye-proekty/16631293',5,3,'2022-12-19 19:52:14+08','https://tass.ru/nacionalnye-proekty/16631293','В Сибири планируют построить более 50 школ в 2023 году');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/ekonomika/16631261',9,3,'2022-12-19 19:52:09+08','https://tass.ru/ekonomika/16631261','В Думе хотят обсудить с МЭР и МО сертификаты на турпоездки родственников участников СВО'),
	 ('https://tass.ru/proisshestviya/16631317',7,3,'2022-12-19 19:50:42+08','https://tass.ru/proisshestviya/16631317','В Новосибирске столкнулись "Газель" и автобус'),
	 ('https://tass.ru/ekonomika/16631205',9,3,'2022-12-19 19:50:13+08','https://tass.ru/ekonomika/16631205','В России данным о смерти клиентов банков присвоили статус налоговой тайны'),
	 ('https://tass.ru/obschestvo/16631179',1,3,'2022-12-19 19:48:41+08','https://tass.ru/obschestvo/16631179','Путин подписал закон о временном отказе в соцобслуживании из-за медицинских показаний'),
	 ('https://tass.ru/obschestvo/16631221',1,3,'2022-12-19 19:47:57+08','https://tass.ru/obschestvo/16631221','Больше половины участников опроса Маска проголосовали за его уход с поста главы Twitter'),
	 ('https://tass.ru/ekonomika/16631165',9,3,'2022-12-19 19:47:46+08','https://tass.ru/ekonomika/16631165','Не сырьевой экспорт Ростовской области к 2030 году вырастет почти на 40%'),
	 ('https://tass.ru/obschestvo/16631157',1,3,'2022-12-19 19:46:39+08','https://tass.ru/obschestvo/16631157','Минздрав прокомментировал возможность введения QR-кодов из-за роста заболеваемости гриппом'),
	 ('https://tass.ru/ekonomika/16630985',9,3,'2022-12-19 19:45:09+08','https://tass.ru/ekonomika/16630985','Эксперт: потолок цен на нефть из РФ не имеет смысла при отсутствии жесткой конкуренции'),
	 ('https://tass.ru/ekonomika/16630863',9,3,'2022-12-19 19:44:16+08','https://tass.ru/ekonomika/16630863','Госдума может принять закон об исламском банкинге в январе - феврале 2023 года'),
	 ('https://tass.ru/ekonomika/16631147',9,3,'2022-12-19 19:43:08+08','https://tass.ru/ekonomika/16631147','Свыше 330 млн рублей направят на поддержку АПК Липецкой области в следующем году');
INSERT INTO public.processed_data (news_id,category_id,source_id,pub_date,link,title) VALUES
	 ('https://tass.ru/ekonomika/16631117',9,3,'2022-12-19 19:43:01+08','https://tass.ru/ekonomika/16631117','Российский зерновой союз оценивает урожай зерна в РФ в 2022 году в объеме 147-151 млн тонн'),
	 ('https://tass.ru/mezhdunarodnaya-panorama/16631099',4,3,'2022-12-19 19:41:56+08','https://tass.ru/mezhdunarodnaya-panorama/16631099','Генсек ОДКБ ожидает, что 2023 год также будет непростым для организации'),
	 ('https://tass.ru/ekonomika/16631017',9,3,'2022-12-19 19:39:38+08','https://tass.ru/ekonomika/16631017','Белоруссия и Россия реализовали 60% союзных программ'),
	 ('https://tass.ru/obschestvo/16630929',1,3,'2022-12-19 19:38:37+08','https://tass.ru/obschestvo/16630929','Росздравнадзор не зафиксировал дефицита антибиотика "Флуимуцил"'),
	 ('https://tass.ru/obschestvo/16631051',1,3,'2022-12-19 19:38:31+08','https://tass.ru/obschestvo/16631051','Самарская область направит около 700 млн рублей на обновление общественного транспорта'),
	 ('https://lenta.ru/news/2022/12/19/barieri/',4,1,'2022-12-19 20:57:00+08','https://lenta.ru/news/2022/12/19/barieri/','В Белоруссии предложили снять все барьеры в интеграции с Россией'),
	 ('https://tass.ru/obschestvo/16632105',1,3,'2022-12-19 20:59:21+08','https://tass.ru/obschestvo/16632105','В Чувашии завершили основные работы по восстановлению электроснабжения после непогоды'),
	 ('https://tass.ru/obschestvo/16631675',1,3,'2022-12-19 20:57:25+08','https://tass.ru/obschestvo/16631675','Президент Аргентины поблагодарил Путина за поздравление с победой на чемпионате мира');
