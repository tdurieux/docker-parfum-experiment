FROM ubuntu:latest
MAINTAINER Felipe Lerena <felipelerena@gmail.com>
RUN apt-get update && apt-get install --no-install-recommends python-pip libtorrent-rasterbar8 python-libtorrent libxml2-dev libxslt1-dev python-lxml python-dev python-yaml -y && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN python /app/setup.py install
