FROM cnbeining/gentle:latest

MAINTAINER David Zhuang <i@cnbeining.com>

COPY requirements.txt /

RUN pip3 install --no-cache-dir -r /requirements.txt

COPY . /app
WORKDIR /app

EXPOSE 8000

ENTRYPOINT ["/app/docker-entrypoint.sh"]
