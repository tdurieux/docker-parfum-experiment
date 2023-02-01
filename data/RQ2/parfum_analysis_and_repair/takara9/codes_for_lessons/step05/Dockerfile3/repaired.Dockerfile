FROM alpine:latest
RUN apk update && apk add --no-cache bash
ADD ./my_daemon3 /my_daemon
CMD ["/bin/bash", "/my_daemon"]

