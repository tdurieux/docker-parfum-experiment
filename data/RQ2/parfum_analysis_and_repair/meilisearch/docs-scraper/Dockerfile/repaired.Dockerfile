FROM python:3.8.4-buster

WORKDIR /docs-scraper

COPY . .

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y python3-pip libnss3 && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir pipenv
RUN pipenv --python 3.8 install
