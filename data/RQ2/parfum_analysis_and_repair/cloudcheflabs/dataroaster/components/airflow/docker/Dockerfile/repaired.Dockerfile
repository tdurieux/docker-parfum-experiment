FROM apache/airflow:2.2.3

USER airflow

RUN pip install --no-cache-dir apache-airflow-providers-apache-livy==2.2.2
RUN pip install --no-cache-dir apache-airflow-providers-amazon==3.2.0
RUN pip install --no-cache-dir apache-airflow-providers-slack==4.2.3