FROM alpine
RUN apk update && apk add --no-cache curl bash
COPY run.sh /test/run.sh
RUN chmod +x /test/run.sh
ENTRYPOINT ["/test/run.sh"]
