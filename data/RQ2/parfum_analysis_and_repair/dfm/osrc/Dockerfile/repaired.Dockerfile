FROM python:3.4

RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends -y postgresql-client-common libpq-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /osrc
WORKDIR /osrc
ADD requirements.txt /osrc/
RUN pip install --no-cache-dir -r requirements.txt
ADD . /osrc/
