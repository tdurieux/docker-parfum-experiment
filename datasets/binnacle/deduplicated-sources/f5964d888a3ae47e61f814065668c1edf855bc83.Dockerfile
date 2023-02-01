FROM alpine:3.9
LABEL maintainer "Shuanglei Tao - tsl0922@gmail.com" \
    maintainer "Damien Duportal - damien.duportal@gmail.com"

RUN apk add --no-cache \
    bash \
    tini \
    ttyd

EXPOSE 7681

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["ttyd", "bash"]
