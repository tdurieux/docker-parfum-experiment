FROM debian:jessie
MAINTAINER Praekelt Foundation <dev@praekeltfoundation.org>

RUN apt-get -qq update && apt-get -qqy --no-install-recommends install python-pip python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -q junebug

EXPOSE 8080
ENTRYPOINT ["jb", "--config=/app/config.yaml"]
