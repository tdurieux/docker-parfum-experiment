FROM python:3.7.6-slim-stretch as builder

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libpq-dev libmariadbclient-dev curl && rm -rf /var/lib/apt/lists/*;

ADD ./ /opt/janitor/

COPY ./docker/init.sh /tmp/init.sh

COPY ./docker/requirements.txt /tmp/requirements.txt

RUN pip3 install --no-cache-dir --upgrade setuptools

RUN pip3 install --no-cache-dir -r /tmp/requirements.txt && pip3 --no-cache install gunicorn && pip3 --no-cache install psycopg2

EXPOSE 8000

WORKDIR /opt/janitor

ENTRYPOINT ["sh", "/tmp/init.sh"]

CMD ["uwsgi", "--http", ":8000", "--mount", "/myapplication=janitor:app", "--enable-threads", "--processes", "5"]
