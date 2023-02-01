FROM python:2.7

MAINTAINER rail@mozilla.com

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -q update && \
    apt-get -q --no-install-recommends --yes install \
        sqlite3 \
        default-libmysqlclient-dev \
        mysql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements/compiled.txt -r -r
