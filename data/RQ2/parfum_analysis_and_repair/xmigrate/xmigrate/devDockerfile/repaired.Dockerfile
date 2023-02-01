FROM node AS stage

WORKDIR /app
COPY ./UI .
WORKDIR /app/xmigrate-ui

FROM ubuntu:18.04

WORKDIR /app

RUN apt update -y
RUN apt install --no-install-recommends -y python3.7 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y wget nginx && rm -rf /var/lib/apt/lists/*;

RUN wget https://launchpadlibrarian.net/422997913/qemu-utils_2.0.0+dfsg-2ubuntu1.46_amd64.deb && apt install --no-install-recommends ./qemu-utils_2.0.0+dfsg-2ubuntu1.46_amd64.deb -y && rm -rf /var/lib/apt/lists/*;

RUN wget https://azcopyvnext.azureedge.net/release20201021/azcopy_linux_amd64_10.6.1.tar.gz && \
    tar -zxf ./azcopy_linux_amd64_10.6.1.tar.gz && \
    mv ./azcopy_linux_amd64_10.6.1/azcopy /usr/bin && rm ./azcopy_linux_amd64_10.6.1.tar.gz

COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p ./logs/ansible/ && mkdir osdisks && touch ./logs/ansible/log.txt && touch ./logs/ansible/migration_log.txt && touch ./logs/ansible/azcopy_log.txt

COPY requirements.txt requirements.txt

ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN python3.7 -m pip install -U pip

RUN python3.7 -m pip install setuptools-rust

RUN python3.7 -m pip install --no-use-pep517 --upgrade pyOpenSSL

RUN python3.7 -m pip install -r requirements.txt

RUN apt update -y
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

COPY . .
RUN rm -rf UI
ENV AZCOPY_BUFFER_GB=0.3
EXPOSE 80

