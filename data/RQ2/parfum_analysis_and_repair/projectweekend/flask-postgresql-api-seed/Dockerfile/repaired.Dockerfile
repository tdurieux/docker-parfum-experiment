FROM ubuntu:trusty

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y socat git software-properties-common python-software-properties postgresql-client-9.3 postgresql-client-common && rm -rf /var/lib/apt/lists/*;

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y python-pip python-psycopg2 libpq-dev python2.7-dev gunicorn libmagic1 && rm -rf /var/lib/apt/lists/*;

RUN mkdir /code
ADD . /code/
WORKDIR /code
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
