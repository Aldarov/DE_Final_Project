import requests
from bs4 import BeautifulSoup
from postgres_helpers import runs_sql_queries


def download_raw_data():
    """Загрузка сырых данных"""

    response = requests.get('https://lenta.ru/rss/')
    rss = BeautifulSoup(response.content, features="xml")
    items = rss.find_all("item")

    def save_to_db(cursor):
        res = []
        for item in items:
            res.append(item.title.text)
        return res

    res = runs_sql_queries(save_to_db)
    print(res, end='\n')

download_raw_data()