FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get --yes update && apt-get --yes --no-install-recommends install build-essential lintian && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes upgrade


RUN mkdir /debbuild
VOLUME ["/debbuild"]

ENTRYPOINT ["/debbuild/makedeb"]
