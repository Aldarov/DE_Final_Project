# import psycopg2
from datetime import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator
from download_raw_data import download_raw_data
from processing_data import processing_data
from update_news_by_category_showcase import update_news_by_category_showcase

with DAG(dag_id="update_news_category_showcase", start_date=datetime(2022, 12, 13), schedule="0 0 * * * *", catchup=False, max_active_runs=1) as dag:
    download_raw_data = PythonOperator(task_id="download_raw_data", python_callable=download_raw_data)
    processing_data = PythonOperator(task_id="processing_data", python_callable=processing_data)
    update_news_by_category_showcase = PythonOperator(task_id="update_news_by_category_showcase",
        python_callable=update_news_by_category_showcase)

    download_raw_data >> processing_data >> update_news_by_category_showcase
