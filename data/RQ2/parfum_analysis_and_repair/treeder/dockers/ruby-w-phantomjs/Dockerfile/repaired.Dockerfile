FROM iron/ruby

RUN apk update && apk upgrade
RUN apk add --no-cache curl
RUN curl -f -Ls https://github.com/fgrehm/docker-phantomjs2/releases/download/v2.0.0-20150722/dockerized-phantomjs.tar.gz | tar xz -C /

#ENTRYPOINT ["/usr/local/bin/phantomjs"]
