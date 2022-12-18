from datetime import datetime

def add_error(error_message, stack_trace = ""):
    """Добавляет ошибку в таблицу logs
        Входные параметры:
            error_message: str -- текст ошибки
            stack_trace: str -- стэк-трейс
    """

    if error_message.strip() == "":
        return

    def add_error_query(cursor):
        cursor.execute("insert into logs(error_date, error_message, stack_trace) values(%s, %s, %s)",
            (datetime.now(), error_message.strip(), stack_trace)
        )

    import postgres_helpers
    postgres_helpers.runs_sql_queries(add_error_query)
