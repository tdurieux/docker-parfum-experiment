FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

COPY forge /bin

RUN apt-get -y update && apt-get -y --no-install-recommends install ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN useradd -ms /bin/bash forge
USER forge
WORKDIR /home/forge

ENTRYPOINT [ "forge" ]
