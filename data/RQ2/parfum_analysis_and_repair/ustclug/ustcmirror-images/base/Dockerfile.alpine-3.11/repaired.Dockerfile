FROM alpine:3.11
# Alpine 3.11 contains Ruby 2.6.x, which homebrew-bottles may need.
LABEL maintainer="Keyu Tao <taoky@ustclug.org>" \
      org.ustcmirror.images=true
ADD ["entry.sh", "savelog", "/usr/local/bin/"]
VOLUME ["/data", "/log"]
ENTRYPOINT ["entry.sh"]
RUN apk add --no-cache bash tzdata su-exec && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime