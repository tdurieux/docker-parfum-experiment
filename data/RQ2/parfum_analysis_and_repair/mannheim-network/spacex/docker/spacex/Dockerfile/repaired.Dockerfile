# Build spacex image
FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;
COPY spacex /opt/spacex/spacex
COPY run.sh /opt/run.sh

WORKDIR /opt/spacex/
CMD /opt/run.sh
