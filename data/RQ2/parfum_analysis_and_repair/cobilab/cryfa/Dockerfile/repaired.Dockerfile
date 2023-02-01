FROM ubuntu:20.04
LABEL maintainer "Morteza Hosseini"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install --no-install-recommends -y cmake g++ && rm -rf /var/lib/apt/lists/*;

COPY . /cryfa
WORKDIR /cryfa
RUN bash install.sh
# ENTRYPOINT ["./cryfa"]
