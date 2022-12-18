import requests
from bs4 import BeautifulSoup
from postgres_helpers import runs_sql_queries
from datetime import datetime
from log_service import add_error

def get_sources():
    """Возвращает источники данных"""

    def get_sources_query(cursor):
        cursor.execute("select * from sources")
        return cursor.fetchall()

    sources = runs_sql_queries(get_sources_query)
    return sources

def is_valid_datа(item):
    """Валидация новости"""

    if item.guid.text.strip() == "":
        add_error(F"Ошибка при добавлении сырых данных ({str(item)}): \nОтсутствует идентификатор новости.")
        return False
    if item.category.text.strip() == "":
        add_error(F"Ошибка при добавлении сырых данных ({str(item)}): \nОтсутствует категория новости.")
        return False
    if item.pubDate.text.strip() == "":
        add_error(F"Ошибка при добавлении сырых данных ({str(item)}): \nНекорректная дата новости.")
        return False
    try:
        datetime.strptime(item.pubDate.text, '%a, %d %b %Y %X %z')
    except:
        add_error(F"Ошибка при добавлении сырых данных ({str(item)}): \nНекорректная дата новости.")
        return False

    return True

def download_raw_data():
    """Загрузка сырых данных"""

    def download_raw_data_queries(cursor):
        sources = get_sources()
        cursor.execute("delete from raw_data")
        for source in sources:
            response = requests.get(source[2])
            rss = BeautifulSoup(response.content, features="xml")
            items = rss.find_all("item")

            for item in items:
                if is_valid_datа(item) == False:
                    continue
                news_datetime = datetime.strptime(item.pubDate.text, '%a, %d %b %Y %X %z')
                cursor.execute("insert into raw_data(guid, source_name, link, title, category, pub_date) values(%s, %s, %s, %s, %s, %s)",
                    (item.guid.text, source[1], item.link.text, item.title.text, item.category.text, news_datetime)
                )

    runs_sql_queries(download_raw_data_queries)