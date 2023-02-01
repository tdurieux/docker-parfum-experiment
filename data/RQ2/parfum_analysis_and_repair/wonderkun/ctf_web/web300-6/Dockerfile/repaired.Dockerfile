FROM ubuntu:16.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && \
      apt-get -y --no-install-recommends install vim python sqlite3 python-pip && \
      apt-get -y autoremove && \
      rm -rf /var/lib/apt/lists/*

COPY ./src /src 
COPY ./start.sh /start.sh
COPY ./pastebin.sql /tmp/pastebin.sql
COPY ./requirements.txt /tmp/requirements.txt
RUN chmod +x /start.sh

RUN /usr/bin/pip install --upgrade pip && \
    pip install --no-cache-dir flask && \
    pip install --no-cache-dir PyJWT && \
    sqlite3 /tmp/pastebin.db < /tmp/pastebin.sql && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm /usr/local/lib/python2.7/dist-packages/jwt/algorithms.pyc

COPY ./algorithms.py  /usr/local/lib/python2.7/dist-packages/jwt/algorithms.py

WORKDIR /src/

EXPOSE 5000
CMD ["/start.sh"]