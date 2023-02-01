FROM ubuntu:latest

ENV TZ=America/Argentina/Buenos_Aires
ENV DEBIAN_FRONTEND=noninteractive

MAINTAINER Marcos Pablo Russo <marcospr1974@gmail.com>

RUN apt-get update \
    && apt-get install --no-install-recommends mat2 -y \
    && mkdir /input && rm -rf /var/lib/apt/lists/*;

VOLUME /input

ENTRYPOINT ["mat2"]
CMD ["-h"]
