FROM alpine:latest
RUN apk add --no-cache -U sysstat
COPY run.sh /bin/run
CMD ["/bin/run"]
