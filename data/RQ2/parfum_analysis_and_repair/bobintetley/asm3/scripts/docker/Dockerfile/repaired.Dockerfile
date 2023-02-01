FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

ADD ./ /tmp/asm3

WORKDIR /tmp/asm3/install/deb

RUN ./makedeb.sh && rm -rf sheltermanager3

RUN apt-get update \
    && apt-get install --no-install-recommends -y make python3 python3-pil python3-webpy python3-mysqldb python3-psycopg2 \
    && apt-get install --no-install-recommends -y imagemagick \
    && apt-get install --no-install-recommends -y wkhtmltopdf \
    && apt-get install --no-install-recommends -y python3-reportlab \
    && apt-get install --no-install-recommends -y python3-requests \
    && apt-get install --no-install-recommends -y python3-boto3 && rm -rf /var/lib/apt/lists/*;

RUN dpkg -i sheltermanager3_`cat ../../VERSION`_all.deb

CMD service sheltermanager3 start && tail -f /var/log/sheltermanager3.log
