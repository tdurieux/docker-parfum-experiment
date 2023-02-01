FROM python:3.8.3-alpine as building

RUN apk add --update --no-cache py3-numpy jpeg-dev zlib-dev gcc musl-dev
ENV PYTHONPATH=/usr/lib/python3.8/site-packages

WORKDIR /instagram-scraper

COPY setup.py /instagram-scraper/setup.py
COPY instagram_scraper /instagram-scraper/instagram_scraper


RUN python /instagram-scraper/setup.py install && rm -rf instagram_scraper.egg-info


FROM python:3.8.3-alpine

RUN mkdir -p /instagram-scraper

COPY docker_entrypoint.sh /instagram-scraper/docker_entrypoint.sh

WORKDIR /instagram-scraper
ENTRYPOINT ["/instagram-scraper/docker_entrypoint.sh"]

COPY --from=building /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=building /usr/local/bin/instagram-scraper /usr/local/bin/instagram-scraper

LABEL "Maintainer"="Alexander Nikolaev <zvava@ya.ru>" \
      "Project page"="https://github.com/arc298/instagram-scraper" \
      "Donations"="https://ko-fi.com/alexnik"
