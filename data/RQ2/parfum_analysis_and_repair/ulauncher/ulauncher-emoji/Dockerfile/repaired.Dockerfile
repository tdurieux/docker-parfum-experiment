FROM python:2

WORKDIR /root/scraper

RUN pip install --no-cache-dir scrapy
