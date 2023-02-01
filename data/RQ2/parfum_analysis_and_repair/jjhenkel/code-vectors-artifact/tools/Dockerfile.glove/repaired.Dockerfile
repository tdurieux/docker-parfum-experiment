FROM python:3

RUN pip install --no-cache-dir gensim && apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

COPY ./glove /app
COPY ./tools/entrypoint-glove.sh /app/entrypoint.sh
COPY ./tools/redis-demo.py /app/redis-demo.py

WORKDIR /app

ENTRYPOINT [ "/app/entrypoint.sh" ]