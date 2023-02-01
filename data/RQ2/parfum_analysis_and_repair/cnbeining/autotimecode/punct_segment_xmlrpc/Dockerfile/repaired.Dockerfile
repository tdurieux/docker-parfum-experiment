FROM tensorflow/tensorflow:1.14.0-py3


MAINTAINER David Zhuang <i@cnbeining.com>

COPY . /app
WORKDIR /app

RUN apt-get install --no-install-recommends -y python3-pip && \
    pip3 install --no-cache-dir -r /app/requirements.txt && rm -rf /var/lib/apt/lists/*;

EXPOSE 8000

ENTRYPOINT ["/app/docker-entrypoint.sh"]
