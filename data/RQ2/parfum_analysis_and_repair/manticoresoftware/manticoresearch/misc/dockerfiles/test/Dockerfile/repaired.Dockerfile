FROM ubuntu:16.04

WORKDIR /tmp
RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf automake libtool g++ \
    build-essential \
    git \
    libexpat1-dev \
    libmysqlclient-dev \
    mysql-client \
    netcat \
    php php-curl php-mysql php-xml \
    python \
    zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /search
RUN mkdir -p /search_src
RUN mkdir -p /aot
