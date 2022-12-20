import psycopg2
import traceback
import os
from log_service import add_error
from dotenv import load_dotenv, dotenv_values

class connection:
    host: str
    port: str
    database: str
    login: str
    password: str

def get_connection():
    """Возвращает объект с параметрами соединения к БД
        Возвращает:
            connection: object --
                объект типа:
                {
                    host: str,           ip-адрес БД
                    port: str,           порт подключения
                    schema: str,         имя таблицы
                    login: str,          логин
                    password: str        пароль
                }
    """
    load_dotenv(os.path.join(os.path.dirname(__file__), '../../../.env'))

    # SECRET_KEY = os.environ.get("SECRET_KEY")

    connection.host = os.environ.get('POSTGRES_HOST')
    connection.port = os.environ.get('POSTGRES_PORT')
    connection.database = os.environ.get('POSTGRES_DB_NAME')
    connection.login = os.environ.get('POSTGRES_USER')
    connection.password = os.environ.get('POSTGRES_PASSWORD')

    print("conn: ", dotenv_values('.env')["POSTGRES_HOST"], connection.host, connection.port, connection.database, connection.login, connection.password)

    return connection

def runs_sql_queries(action):
    """Выполняет действие, которое запускает одно или несколько sql-запросов в одной транзакции\n
        Входные параметры:
            action: {lambda cursor: any} -- функция в которую передается курсор psycopg2\n
        Возвращает:
            any -- результат выполнения функция action
    """
    connection = get_connection()
    conn = psycopg2.connect(host=connection.host, port=connection.port, user=connection.login, password=connection.password, database=connection.database)
    try:
        with conn:
            with conn.cursor() as cursor:
                result = action(cursor)
    except Exception as e:
        add_error(str(e), traceback.format_exc())
        raise
    finally:
        conn.close()

    return result
