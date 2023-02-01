FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl ca-certificates amqp-tools python python-pip && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt requirements.txt
COPY ./prime_numpy.py /prime_numpy.py
RUN pip install --no-cache-dir -r /requirements.txt

CMD  /usr/bin/amqp-consume --url=$BROKER_URL -q $QUEUE -c 1 /prime_numpy.py




