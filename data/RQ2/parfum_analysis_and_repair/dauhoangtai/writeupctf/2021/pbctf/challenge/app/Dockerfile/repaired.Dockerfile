FROM tiangolo/meinheld-gunicorn-flask:python3.8-2020-06-06

RUN pip install --no-cache-dir redis

COPY ./app.py /app/main.py
