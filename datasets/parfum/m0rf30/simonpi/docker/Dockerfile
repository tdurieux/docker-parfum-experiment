FROM alpine:3.11
LABEL maintainer="Gianluca Boiano <morf3089@gmail.com>"

COPY bin/setup /usr/bin
RUN \
apk update; \
apk add --no-cache \
bash; \
setup
# Expose raspberry ssh port mapped on 2222 by qemu
EXPOSE 2222
CMD ["simonpi", "-h"]
