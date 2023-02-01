FROM ubuntu:16.04

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip python3-all-dev && \
    pip3 install --no-cache-dir Django gunicorn && \
    apt-get -y  autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /app/
COPY ./pastestatic /app/pastestatic
COPY ./start.sh /start.sh

RUN chmod +x /start.sh

WORKDIR /app/pastestatic/

CMD ["/start.sh"]
EXPOSE 8000