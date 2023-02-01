FROM panubo/sshd:1.0.3

RUN apk update && \
    apk add --no-cache sudo
