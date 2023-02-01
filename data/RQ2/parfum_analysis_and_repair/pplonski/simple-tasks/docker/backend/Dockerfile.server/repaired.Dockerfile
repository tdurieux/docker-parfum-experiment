FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends -y python3.6 python3.6-dev python3-pip && \
    apt-get install --no-install-recommends -y curl && \
    curl -f https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;



WORKDIR /app
COPY requirements.txt .
RUN rm -f /usr/bin/python && ln -s /usr/bin/python3.6 /usr/bin/python
RUN rm -f /usr/bin/python3 && ln -s /usr/bin/python3.6 /usr/bin/python3

RUN pip3 install --no-cache-dir -r requirements.txt

ADD ./backend /app/backend
ADD ./docker /app/docker

WORKDIR /app/backend/server
RUN ./manage.py collectstatic --noinput


WORKDIR /app/client
ADD ./client /app/client

RUN ls -al /app/client/build

ENV PUBLIC_URL /static/client
RUN npm install && npm run build && rm -rf node_modules && npm cache clean --force;


WORKDIR /app/backend/server/static/client
RUN cp -r /app/client/build/. /app/backend/server/static/client/

RUN cat /app/client/build/index.html
RUN cat /app/backend/server/static/client/index.html

RUN ls -al /app/client/build/static/js
RUN ls -al /app/backend/server/static/client/static/js

WORKDIR /app
