FROM gliderlabs/alpine

RUN apk --update --no-cache add curl jq

ENTRYPOINT [ "/bin/sh", "-l" ]
