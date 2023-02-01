# FROM ubuntu:16.04
FROM python:3.9

# cache the building stage of docker
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y wget wkhtmltopdf git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y fontconfig fonts-wqy-zenhei && rm -rf /var/lib/apt/lists/*;
RUN fc-cache -fv

RUN python3 --version

WORKDIR /antigenbot


COPY requirements.txt requirements.txt
COPY Makefile Makefile
RUN make install

ENV IN_DOCKER=true

CMD [ "make", "run"]