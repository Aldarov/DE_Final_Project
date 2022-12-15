import psycopg2
# from airflow.models import Variable
# from airflow.hooks.base_hook import BaseHook

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
    # conn_name = Variable.get("conn_name")
    # connection = BaseHook.get_connection(conn_name)
    class connection:
        host: str = "localhost"
        port: str = "5432"
        schema: str = "news_analysis"
        login: str = "postgres"
        password: str = "postgres"
    return connection

def runs_sql_queries(action):
    """Выполняет действие, которое запускает одно или несколько sql-запросов в одной транзакции\n
        Входные параметры:
            action: {lambda cursor: any} -- функция в которую передается курсор psycopg2\n
        Возвращает:
            any -- результат выполнения функция action
    """
    connection = get_connection()
    conn = psycopg2.connect(host=connection.host, port=connection.port, user=connection.login, password=connection.password, database=connection.schema)
    try:
        with conn:
            with conn.cursor() as cursor:
                result = action(cursor)
    except:
        raise
    finally:
        conn.close()

    return result
