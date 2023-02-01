FROM python:3.9-bullseye

RUN mkdir -p /app/yearn-exporter
WORKDIR /app/yearn-exporter

ADD requirements.txt  ./
RUN pip3 install --no-cache-dir -r requirements.txt

ADD . /app/yearn-exporter

ENTRYPOINT ["./entrypoint.sh"]
