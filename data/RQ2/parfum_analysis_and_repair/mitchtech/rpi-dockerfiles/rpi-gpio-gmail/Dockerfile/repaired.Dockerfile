FROM mitchtech/rpi-gpio-python

MAINTAINER Michael J. Mitchell <michael@mitchtech.net>

RUN pip install --no-cache-dir feedparser

COPY ./gpio_gmail.py /bin/gpio_gmail.py

VOLUME ["/data"]

WORKDIR /data
