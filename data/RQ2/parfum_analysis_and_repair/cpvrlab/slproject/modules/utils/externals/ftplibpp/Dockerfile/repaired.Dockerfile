FROM debian:jessie

RUN apt-get -y update && apt-get -y --no-install-recommends install build-essential libssl-dev && rm -rf /var/lib/apt/lists/*;
# COPY / /src
# WORKDIR /src
# CMD make
