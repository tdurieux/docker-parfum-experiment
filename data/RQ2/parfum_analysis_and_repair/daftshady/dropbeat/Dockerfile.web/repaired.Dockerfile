FROM python:2.7

RUN apt-get update && apt-get install --no-install-recommends -y python-mysqldb && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

RUN pip install --no-cache-dir django==1.10.2 enum34 mysql-python requests bs4 celery

ADD . /app

EXPOSE 8000
