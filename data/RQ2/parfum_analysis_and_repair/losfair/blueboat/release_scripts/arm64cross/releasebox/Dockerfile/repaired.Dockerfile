FROM ubuntu:20.04

COPY ./run.sh /
COPY ./blueboat.deb /
RUN apt update && apt install --no-install-recommends -y ca-certificates /blueboat.deb && rm /blueboat.deb && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT /run.sh
