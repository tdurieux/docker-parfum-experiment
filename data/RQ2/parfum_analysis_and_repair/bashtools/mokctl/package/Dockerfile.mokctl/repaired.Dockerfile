FROM alpine:3.11
COPY mokctl.deploy /usr/bin/mokctl
RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash ncurses util-linux docker
ENTRYPOINT [ "/usr/bin/mokctl" ]
CMD [ "--help" ]
