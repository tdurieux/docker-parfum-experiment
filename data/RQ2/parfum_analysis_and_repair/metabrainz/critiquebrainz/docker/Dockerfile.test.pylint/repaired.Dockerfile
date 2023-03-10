FROM metabrainz/python:3.10-20220315

RUN mkdir /data
RUN mkdir /code
WORKDIR /code

# Python dependencies
RUN apt-get update \
     && apt-get install -y --no-install-recommends \
                        build-essential \
                        ca-certificates \
                        cron \
                        git \
                        libpq-dev \
                        libffi-dev \
                        libssl-dev \
                        libxml2-dev \
                        libxslt1-dev \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /code/

CMD touch /data/pylint.out && find . -iname "*.py" | xargs pylint -j 4 | tee /data/pylint.out && \
    touch /data/flake8.out && find . -iname "*.py" | xargs flake8 -j 4 | tee /data/flake8.out