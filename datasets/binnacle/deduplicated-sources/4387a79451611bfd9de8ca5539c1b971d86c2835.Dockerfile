FROM ubuntu:18.04
RUN apt-get update && \
      apt-get install -y --no-install-recommends ca-certificates=20180409 && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/*
COPY ./bin/engine .
CMD [ "./engine" ]
