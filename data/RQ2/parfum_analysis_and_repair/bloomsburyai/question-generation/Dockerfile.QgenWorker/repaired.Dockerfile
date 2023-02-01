FROM ubuntu:latest
MAINTAINER Tom Hosking "code@tomho.sk"

RUN apt-get update -y && apt-get install --no-install-recommends -y python3 python3-pip python3-dev build-essential && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /app/requirements.txt

WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt

RUN python3 -m nltk.downloader punkt
RUN python3 -m spacy download en

ADD ./src /app/src

ENV PYTHONPATH "${PYTHONPATH}:./src"
WORKDIR /app/src
#ENTRYPOINT ["celery"]
CMD ["celery", "-A", "demo.qgenworker", "worker", "--loglevel=info","--concurrency=1","--queues=qgen"]