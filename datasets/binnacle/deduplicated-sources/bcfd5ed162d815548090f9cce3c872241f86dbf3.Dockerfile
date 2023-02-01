FROM python:3

RUN pip install gensim && apt-get update && apt-get install -y build-essential

COPY ./glove /app
COPY ./tools/entrypoint-glove.sh /app/entrypoint.sh
COPY ./tools/redis-demo.py /app/redis-demo.py

WORKDIR /app 

ENTRYPOINT [ "/app/entrypoint.sh" ]