FROM ubuntu:14.04.4

RUN apt-get update -q -y && \
    apt-get upgrade -q -y

RUN apt-get install --no-install-recommends -q -y python python-dev libssl-dev libffi-dev && \
    apt-get install --no-install-recommends -q -y wget && \
    wget "https://bootstrap.pypa.io/get-pip.py" -O /dev/stdout | python && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir twisted petlib redis msgpack-python

RUN mkdir /app

WORKDIR /app
ADD core.py core.py
ADD checker.py checker.py

EXPOSE 9090 9191