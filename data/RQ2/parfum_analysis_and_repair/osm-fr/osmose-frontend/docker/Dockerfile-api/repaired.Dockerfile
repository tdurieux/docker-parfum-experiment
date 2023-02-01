FROM python:3.7
MAINTAINER Frédéric Rodrigo <fred.rodrigo@gmail.com>

RUN mkdir -p /data/work/root/results/

RUN apt update && \
    apt install -y --no-install-recommends \
        bzip2 \
        gettext \
        postgresql-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD ./requirements.txt /data/project/osmose/frontend/requirements.txt
WORKDIR /data/project/osmose/frontend
RUN pip install --no-cache-dir -r requirements.txt

ADD . /data/project/osmose/frontend

ENV LANG en_US.UTF-8
CMD ./osmose-standalone-bottle.py
EXPOSE 20009
