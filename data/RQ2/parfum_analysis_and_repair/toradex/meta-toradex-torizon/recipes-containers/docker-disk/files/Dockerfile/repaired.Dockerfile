FROM docker:17.06-dind
RUN apk add --no-cache --update util-linux shadow e2fsprogs && rm -rf /var/cache/apk/*
ADD entry.sh /entry.sh
RUN chmod a+x /entry.sh

CMD /entry.sh
