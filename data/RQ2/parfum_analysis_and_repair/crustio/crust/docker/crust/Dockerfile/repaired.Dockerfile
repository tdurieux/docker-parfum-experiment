# Build crust image
FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;
COPY crust /opt/crust/crust
COPY run.sh /opt/run.sh

WORKDIR /opt/crust/
CMD /opt/run.sh
