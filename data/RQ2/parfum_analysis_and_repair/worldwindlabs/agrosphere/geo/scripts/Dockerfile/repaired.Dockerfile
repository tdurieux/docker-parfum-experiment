# Main tuttle needs
FROM debian:jessie
MAINTAINER Lexman <tuttle@lexman.org>
RUN apt-get update && apt-get install --no-install-recommends -y python python-psycopg2 postgresql-client python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir https://github.com/lexman/tuttle/archive/v0.3-rc1.zip
VOLUME ["/project"]
WORKDIR /project

# Specific for geo-countries-110 :
RUN apt-get update && apt-get install --no-install-recommends -y git && git config --global user.email "tuttle-bot@lexman.org" && git config --global user.name "Bot" && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y unzip gdal-bin && rm -rf /var/lib/apt/lists/*;
