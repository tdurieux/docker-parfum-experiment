FROM ubuntu:16.04

RUN apt-get update \
	&& apt-get -y --no-install-recommends install postgresql && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
COPY . .
