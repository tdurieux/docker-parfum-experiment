FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends -y python3.6 python3.6-dev python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY requirements.txt .
RUN rm -f /usr/bin/python && ln -s /usr/bin/python3.6 /usr/bin/python
RUN rm -f /usr/bin/python3 && ln -s /usr/bin/python3.6 /usr/bin/python3

RUN pip3 install --no-cache-dir -r requirements.txt

ADD ./backend /app/backend
ADD ./docker /app/docker
