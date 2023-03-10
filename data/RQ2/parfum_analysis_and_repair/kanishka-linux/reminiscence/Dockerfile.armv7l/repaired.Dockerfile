From python:3.6-slim-stretch

WORKDIR /usr/src/reminiscence

RUN apt-get update \
  && apt-get install --no-install-recommends -y chromium netcat wget \
  && wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.raspbian.stretch_armhf.deb \
  && apt-get install --no-install-recommends -y ./wkhtmltox_0.12.5-1.raspbian.stretch_armhf.deb \
  && rm ./wkhtmltox_0.12.5-1.raspbian.stretch_armhf.deb \
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN apt-get update && apt-get install --no-install-recommends -y \
        build-essential \
        libpq-dev \
        libxml2 \
        libxml2-dev \
        libxslt1-dev \
        python-dev \
        libpython3-all-dev \
        zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/reminiscence

RUN bash

RUN mkdir -p logs archive tmp \
  && python manage.py applysettings --docker yes \
  && python manage.py generatesecretkey
