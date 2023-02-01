FROM docker
MAINTAINER Philipp C. Heckel <philipp.heckel@gmail.com>
RUN apk add --no-cache tmux asciinema ttyd
COPY replbot /usr/bin

ENTRYPOINT ["replbot"]
