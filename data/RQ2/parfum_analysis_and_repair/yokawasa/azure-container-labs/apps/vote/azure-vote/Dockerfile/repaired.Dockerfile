FROM    tiangolo/uwsgi-nginx-flask:python3.6

RUN apt-get update && \
        apt-get install --no-install-recommends default-libmysqlclient-dev -y && \
        pip install --no-cache-dir mysql-connector-python-rf && rm -rf /var/lib/apt/lists/*;

ADD     /azure-vote /app
