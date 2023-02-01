FROM tiangolo/uwsgi-nginx-flask:python3.7

RUN pip install --no-cache-dir requests

COPY ./app /app
