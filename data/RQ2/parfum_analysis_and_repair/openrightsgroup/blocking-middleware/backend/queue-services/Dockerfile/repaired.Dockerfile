FROM python:2.7

RUN apt-get update && \
    apt-get -y --no-install-recommends install whois && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN mkdir /srv/queue-service
COPY requirements.txt /srv/queue-service/
RUN pip install --no-cache-dir -r /srv/queue-service/requirements.txt

COPY *.py /srv/queue-service/
COPY config.docker.ini /srv/queue-service/config.ini

WORKDIR /srv/queue-service

