# import psycopg2
from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.sensors.python import PythonSensor
from airflow.operators.python import BranchPythonOperator
from airflow.exceptions import AirflowFailException
from airflow.hooks.base_hook import BaseHook
from airflow.models import Variable
from download_raw_data import download_raw_data


with DAG(dag_id="update_news_category_showcase", start_date=datetime(2022, 12, 13), schedule="0 0 * * * *", catchup=False, max_active_runs=1) as dag:
    download_raw_data = PythonOperator(task_id="download_raw_data", python_callable=download_raw_data)
    # python_task1 = PythonOperator(task_id="task1", python_callable = hello)
    # add_numbers_to_file = PythonOperator(task_id="add_numbers_to_file", python_callable = add_numbers_to_file, depends_on_past=True)
    # result_calculation = PythonOperator(task_id="result_calculation", python_callable = result_calculation, depends_on_past=True)
    # check_file = PythonSensor(task_id="check_file", python_callable=check_file)
    # branch_check_file = BranchPythonOperator(task_id='branch_check_file', python_callable=branch_check_file)
    # task_to_fail = PythonOperator(task_id="task_to_fail", python_callable = task_to_fail)
    # create_db = PythonOperator(task_id="create_db", python_callable = create_db, depends_on_past=True)
    # add_result_to_db = PythonOperator(task_id="add_result_to_db", python_callable = add_result_to_db, trigger_rule='none_failed_or_skipped', depends_on_past=True)

    download_raw_data
