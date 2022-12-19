--Суррогатный ключ категории
--Название категории

--Общее количество новостей из всех источников по данной категории за все время
--Количество новостей данной категории для каждого из источников за все время

--Общее количество новостей из всех источников по данной категории за последние сутки
--Количество новостей данной категории для каждого из источников за последние сутки

--Среднее количество публикаций по данной категории в сутки
--День, в который было сделано максимальное количество публикаций по данной категории
--Количество публикаций новостей данной категории по дням недели

select pd.category_id, c."name" as category_name, s."name" as source_name,
	t1.number_of_news_by_category,
	count(distinct pd.news_id) as number_of_news_by_category_and_source,
	t2.number_of_news_by_category_last_day,
	t3.number_of_news_by_category_and_source_last_day
from processed_data pd
	inner join categories c on pd.category_id = c.id
	inner join sources s on pd.source_id = s.id
	left join
	(
		select category_id, count(distinct news_id) as number_of_news_by_category
		from processed_data pd
		group by category_id
	) t1 on pd.category_id = t1.category_id
	left join
	(
		select category_id, count(distinct news_id) as number_of_news_by_category_last_day
		from processed_data
		where pub_date between (now() - interval '1 DAY') and now()
		group by category_id
	) t2 on pd.category_id = t2.category_id
	left join
	(
		select category_id, source_id, count(distinct news_id) as number_of_news_by_category_and_source_last_day
		from processed_data
		where pub_date between (now() - interval '1 DAY') and now()
		group by category_id, source_id
	) t3 on pd.category_id = t3.category_id and pd.source_id = t3.source_id
group by pd.category_id, c."name", s.id, s."name",
    t1.number_of_news_by_category, t2.number_of_news_by_category_last_day, t3.number_of_news_by_category_and_source_last_day
order by pd.category_id, s.id;

select category_id, count(distinct news_id) as number_of_news_by_category_last_day
from processed_data
where pub_date between (now() - interval '1 DAY') and now()
group by category_id;

select category_id, source_id, count(distinct news_id) as number_of_news_by_category_and_source_last_day
from processed_data
where pub_date between (now() - interval '1 DAY') and now()
group by category_id, source_id;
