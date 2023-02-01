FROM ubuntu
MAINTAINER rail@mozilla.com
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -q update \
    && apt-get install --no-install-recommends --yes -q \
    libmysqlclient-dev \
    npm \
    phantomjs \
    python-tox \
    python-dev \
    sqlite3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY Dockerfile-tests /Dockerfile
