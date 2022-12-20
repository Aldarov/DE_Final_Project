from postgres_helpers import runs_sql_queries

def update_news_by_category_showcase():
    """Обновляем витрину данных - анализ новостей по категориям"""

    def update_showcase(cursor):
        #Удаляем все записи из табл. news_by_category_showcase
        cursor.execute("delete from news_by_category_showcase;")

        #Вставляем новые данные
        cursor.execute("""
            INSERT INTO news_by_category_showcase(category_id, category_name, source_name, number_of_news_by_category, number_of_news_by_category_and_source, number_of_news_by_category_last_day,
                number_of_news_by_category_and_source_last_day, avg_number_of_news_by_category_per_day, day_with_max_number_of_news_by_category,
                news_count_on_mon, news_count_on_tue, news_count_on_wed, news_count_on_thu, news_count_on_fri, news_count_on_sat, news_count_on_sun
            )
            select pd.category_id, c."name" as category_name, s."name" as source_name,
                t1.number_of_news_by_category,
                count(distinct pd.news_id) as number_of_news_by_category_and_source,
                t2.number_of_news_by_category_last_day,
                t3.number_of_news_by_category_and_source_last_day,
                t4.avg_number_of_news_by_category_per_day,
                t4.day_with_max_number_of_news_by_category,
                t5.news_count_on_mon,
                t5.news_count_on_tue,
                t5.news_count_on_wed,
                t5.news_count_on_thu,
                t5.news_count_on_fri,
                t5.news_count_on_sat,
                t5.news_count_on_sun
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
                left join
                (
                    select category_id,
                        round(avg(news_count)) as avg_number_of_news_by_category_per_day,
                        max(case when row_num = 1 then pub_date else null end) as day_with_max_number_of_news_by_category
                    from
                    (
                        select category_id, pub_date, news_count, row_number() over(partition by category_id order by news_count desc) as row_num
                        from
                        (
                            select category_id, date(pub_date) as pub_date, count(distinct news_id) as news_count
                            from processed_data
                            group by category_id, date(pub_date)
                        ) g1
                    ) g2
                    group by category_id
                ) t4 on pd.category_id = t4.category_id
                left join
                (
                    select category_id,
                        sum(case when day_of_week = 1 then news_count else 0 end) as news_count_on_mon,
                        sum(case when day_of_week = 2 then news_count else 0 end) as news_count_on_tue,
                        sum(case when day_of_week = 3 then news_count else 0 end) as news_count_on_wed,
                        sum(case when day_of_week = 4 then news_count else 0 end) as news_count_on_thu,
                        sum(case when day_of_week = 5 then news_count else 0 end) as news_count_on_fri,
                        sum(case when day_of_week = 6 then news_count else 0 end) as news_count_on_sat,
                        sum(case when day_of_week = 7 then news_count else 0 end) as news_count_on_sun
                    from
                    (
                        select category_id, extract(isodow from pub_date) as day_of_week, count(distinct news_id) as news_count
                        from processed_data
                        group by category_id, extract(isodow from pub_date)
                    ) g1
                    group by category_id
                ) t5 on pd.category_id = t5.category_id
            group by pd.category_id, c."name", s.id, s."name",
                t1.number_of_news_by_category, t2.number_of_news_by_category_last_day, t3.number_of_news_by_category_and_source_last_day,
                t4.avg_number_of_news_by_category_per_day, t4.day_with_max_number_of_news_by_category,
                t5.news_count_on_mon, t5.news_count_on_tue, t5.news_count_on_wed, t5.news_count_on_thu, t5.news_count_on_fri, t5.news_count_on_sat, t5.news_count_on_sun
            order by pd.category_id, s.id;
        """)

    runs_sql_queries(update_showcase)