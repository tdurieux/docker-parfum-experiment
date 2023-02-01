FROM python:3.6-buster

RUN apt-get update -qq && apt-get install --no-install-recommends -y gettext \
        postgresql-client libgdal-dev libgeos-dev musl-dev ruby-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/alphagov/mapit.git

WORKDIR /mapit

RUN pip install --no-cache-dir shapely six
RUN pip install --no-cache-dir --upgrade pip wheel setuptools
RUN pip install --no-cache-dir -r requirements.txt
