FROM alpine:latest
RUN apk update && apk add --no-cache bash
ADD ./my_daemon2 /my_daemon
CMD ["/bin/bash", "/my_daemon"]

