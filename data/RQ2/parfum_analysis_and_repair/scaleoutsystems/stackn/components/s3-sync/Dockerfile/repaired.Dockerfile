FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y s3fs && rm -rf /var/lib/apt/lists/*;

COPY run.sh /run.sh
ENTRYPOINT exec /run.sh
