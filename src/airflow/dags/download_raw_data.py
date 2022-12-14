import requests
from bs4 import BeautifulSoup
from postgres_helpers import runs_sql_queries
from datetime import datetime


sources = [
    {
        "name": "lenta.ru",
        "url_rss": "https://lenta.ru/rss"
    },
    {
        "name": "vedomosti.ru",
        "url_rss": "https://www.vedomosti.ru/rss/news"
    },
    {
        "name": "tass.ru",
        "url_rss": "https://tass.ru/rss/v2.xml"
    }
]

def download_raw_data():
    """Загрузка сырых данных"""

    def insert_rss(cursor):
        cursor.execute("delete from raw_data")
        for source in sources:
            response = requests.get(source["url_rss"])
            rss = BeautifulSoup(response.content, features="xml")
            items = rss.find_all("item")

            for item in items:
                news_datetime = datetime.strptime(item.pubDate.text, '%a, %d %b %Y %X %z')
                cursor.execute("insert into raw_data(guid, source_name, link, title, category, pub_date) values(%s, %s, %s, %s, %s, %s)",
                    (item.guid.text, source["name"], item.link.text, item.title.text, item.category.text, news_datetime)
                )

    runs_sql_queries(insert_rss)

download_raw_data()