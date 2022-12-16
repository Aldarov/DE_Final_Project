from postgres_helpers import runs_sql_queries

def processing_data():
    def add_to_processed_data(cursor):
        cursor.execute("""
            insert into processed_data(news_id, source_id, category_id, pub_date, link, title)
            select rd.guid as news_id, s.id as source_id, cr.category_id, rd.pub_date, rd.link, rd.title
            from
                raw_data rd
                inner join source_categories sc on sc."name" = rd.category
                inner join sources s on rd.source_name = s."name"
                inner join categories_relationship cr on cr.source_category_id = sc.id
            where rd.guid not in (select distinct news_id from processed_data)
            group by rd.guid, s.id, cr.category_id, rd.pub_date, rd.link, rd.title
            order by s.id, rd.pub_date desc
        """)

    runs_sql_queries(add_to_processed_data)