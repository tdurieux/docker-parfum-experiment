FROM python:3.4

MAINTAINER Daniele Venzano <venza@brownhat.org>

RUN mkdir -p /opt/zoe
WORKDIR /opt/zoe

RUN apt-get update && apt-get install --no-install-recommends -y libldap2-dev libsasl2-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY . /opt/zoe
RUN pip install --no-cache-dir -r requirements.txt

RUN echo 'admin,admin,admin' > /opt/zoe/zoepass.csv

VOLUME /etc/zoe/

RUN python3 ./zoe-api.py --write-config /etc/zoe/zoe.conf
