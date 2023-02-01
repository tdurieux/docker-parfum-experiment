FROM alpine

RUN apk add --no-cache curl
ADD ping.sh /ping.sh

CMD [ "/bin/sh", "/ping.sh" ]

