FROM python:3.7

# supervisord setup
RUN apt-get update && apt-get install --no-install-recommends -y supervisor && apt-get install --no-install-recommends -y python3-setuptools && rm -rf /var/lib/apt/lists/*;
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Airflow setup
ENV AIRFLOW_HOME=/Users/sushantikerani/airflow

RUN pip install --no-cache-dir apache-airflow
COPY /output/mnist-pipeline/main.py $AIRFLOW_HOME/dags/

RUN airflow db init

EXPOSE 8080
CMD ["/usr/bin/supervisord"]