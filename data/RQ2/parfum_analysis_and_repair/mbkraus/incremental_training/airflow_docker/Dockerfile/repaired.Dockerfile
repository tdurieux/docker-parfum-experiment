FROM puckel/docker-airflow

WORKDIR /usr/local/airflow/
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

