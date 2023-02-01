FROM nnadeau/docker-doxygen

RUN apk update && apk add --no-cache \
  make execline

RUN mkdir math
COPY . ./math
WORKDIR ./math
