FROM ubuntu:16.04

# cache the building stage of docker
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python3 wget wkhtmltopdf && rm -rf /var/lib/apt/lists/*;

RUN python3 --version

RUN python3 -m pip install pip

WORKDIR /antigenbot

# cache the building stage of docker
COPY requirements.txt requirements.txt
COPY Makefile Makefile
RUN make install

ENV IN_DOCKER=true

CMD [ "make", "run"]