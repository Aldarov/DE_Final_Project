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


def task_to_fail():
    raise AirflowFailException("Входной файл пуст или его не существует")

def get_connection():
    conn_name = Variable.get("conn_name")
    print("conn_name: " + conn_name)
    return BaseHook.get_connection(conn_name)

# def create_db():
#     connection = get_connection()
#     conn = psycopg2.connect(host=connection.host, port=connection.port, user=connection.login, password=connection.password, database=connection.schema)
#     cursor = conn.cursor()
#     cursor.execute("create table if not exists data(value_1 integer NOT NULL, value_2 integer NOT NULL)")
#     with open(path_to_file) as file:
#         lines = file.readlines()[:-1]
#         for line in lines:
#             digits = line.split(' ')
#             value_1 = int(digits[0])
#             value_2 = int(digits[1])
#             cursor.execute(f"insert into data(value_1, value_2) values({value_1}, {value_2})")
#     conn.commit()

#     cursor.close()
#     conn.close()

# def add_result_to_db():
#     connection = get_connection()
#     conn = psycopg2.connect(host=connection.host, port=connection.port, user=connection.login, password=connection.password, database=connection.schema)
#     cursor = conn.cursor()
#     cursor.execute("delete from data")
#     cursor.execute("alter table data ADD COLUMN IF NOT EXISTS coef integer;")
#     sum_col_1 = 0
#     sum_col_2 = 0
#     with open(path_to_file) as file:
#         lines = file.readlines()[:-1]
#         for line in lines:
#             digits = line.split(' ')
#             value_1 = int(digits[0])
#             value_2 = int(digits[1])
#             sum_col_1 += value_1
#             sum_col_2 += value_2
#             coef = sum_col_1 - sum_col_2
#             cursor.execute(f"insert into data(value_1, value_2, coef) values({value_1}, {value_2}, {coef})")
#     conn.commit()

#     cursor.close()
#     conn.close()


with DAG(dag_id="update_news_category_showcase", start_date=datetime(2022, 12, 13), schedule="0 0 * * * *", catchup=False, max_active_runs=1) as dag:
    hello_task = BashOperator(task_id="hello", bash_command="echo hello")
    # python_task1 = PythonOperator(task_id="task1", python_callable = hello)
    # add_numbers_to_file = PythonOperator(task_id="add_numbers_to_file", python_callable = add_numbers_to_file, depends_on_past=True)
    # result_calculation = PythonOperator(task_id="result_calculation", python_callable = result_calculation, depends_on_past=True)
    # check_file = PythonSensor(task_id="check_file", python_callable=check_file)
    # branch_check_file = BranchPythonOperator(task_id='branch_check_file', python_callable=branch_check_file)
    # task_to_fail = PythonOperator(task_id="task_to_fail", python_callable = task_to_fail)
    # create_db = PythonOperator(task_id="create_db", python_callable = create_db, depends_on_past=True)
    # add_result_to_db = PythonOperator(task_id="add_result_to_db", python_callable = add_result_to_db, trigger_rule='none_failed_or_skipped', depends_on_past=True)

    hello_task
