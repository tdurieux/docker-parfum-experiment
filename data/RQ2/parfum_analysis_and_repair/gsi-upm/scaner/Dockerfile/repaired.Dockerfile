FROM python:3.4

ENV REDIS_HOST redis
ENV ORIENTDB_HOST orientdb

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN pip install --no-cache-dir --upgrade pip
RUN apt-get update && apt-get install --no-install-recommends build-essential gfortran libatlas-base-dev python-pip python-dev -y && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
ADD . /usr/src/app

ADD run-web.sh /usr/local/bin/
ADD run-celery.sh /usr/local/bin/
ADD run-flower.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run-web.sh
RUN chmod +x /usr/local/bin/run-celery.sh
RUN chmod +x /usr/local/bin/run-flower.sh

CMD ["run-web.sh"]
