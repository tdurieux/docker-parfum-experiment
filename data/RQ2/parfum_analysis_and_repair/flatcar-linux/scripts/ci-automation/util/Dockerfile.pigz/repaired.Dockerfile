FROM alpine
RUN apk add --no-cache pigz
ENTRYPOINT [ "/usr/bin/pigz" ]
CMD [ "-h" ]
