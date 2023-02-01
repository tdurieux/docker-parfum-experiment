FROM kaldiasr/kaldi:latest

MAINTAINER David Zhuang <i@cnbeining.com>

COPY . /app
WORKDIR /app

RUN apt-get install --no-install-recommends -y python3-pip && \
    pip3 install --no-cache-dir -r /app/requirements.txt && rm -rf /var/lib/apt/lists/*;

EXPOSE 8000

ENTRYPOINT ["/app/docker-entrypoint.sh"]
