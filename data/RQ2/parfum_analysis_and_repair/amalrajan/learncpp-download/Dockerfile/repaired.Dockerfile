FROM ubuntu:focal

MAINTAINER "Amal Rajan <amalrajan74@gmail.com>"

WORKDIR /app

COPY requirements.txt requirements.txt

COPY . .

RUN set -ex \
    && apt-get -y update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
       libglib2.0-dev libpango-1.0-0 libpangoft2-1.0-0 python3 python3-pip \
    && pip3 install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

CMD ["python3", "/app/source/main.py",  "--weasy"]
