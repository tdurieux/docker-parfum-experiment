FROM python:3.9.4-slim-buster

WORKDIR /usr/src/app
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt update && apt install --no-install-recommends gcc -y && rm -rf /var/lib/apt/lists/*;
COPY . .
WORKDIR api/api
RUN pip install --no-cache-dir --upgrade pip; pip install --no-cache-dir poetry; poetry config virtualenvs.create false; poetry install; poetry add uwsgi
CMD poetry shell; uwsgi --master \
  --single-interpreter \
  --workers $WORKERS \
  --gevent $ASYNC_CORES \
  --protocol http \
  --socket 0.0.0.0:$APP_PORT \
  --module patched:app
