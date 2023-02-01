FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

RUN pip install --no-cache-dir water-healer requests streamz==0.5.2

RUN pip install --no-cache-dir tensorflow transformers

RUN pip install --no-cache-dir confluent_kafka distributed dask torch

RUN pip install --no-cache-dir gevent eventlet

COPY ./app /app

WORKDIR /