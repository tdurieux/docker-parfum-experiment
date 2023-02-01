FROM apache/airflow:2.1.2-python3.8

RUN pip install --no-cache-dir --upgrade pip==20.2.4
RUN pip install --no-cache-dir apache-airflow-providers-google
