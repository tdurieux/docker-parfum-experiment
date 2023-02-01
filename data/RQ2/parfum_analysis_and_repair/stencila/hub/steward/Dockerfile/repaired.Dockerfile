FROM ubuntu:20.04

RUN apt-get update \
 && apt-get install --no-install-recommends -y s3fs && rm -rf /var/lib/apt/lists/*;

COPY *.sh ./

CMD ["./cmd.sh"]
