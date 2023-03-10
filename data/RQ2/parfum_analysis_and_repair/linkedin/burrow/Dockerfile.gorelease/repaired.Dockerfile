FROM alpine:3.15
LABEL maintainer="LinkedIn Burrow https://github.com/linkedin/Burrow"

WORKDIR /app
COPY burrow /app/

CMD ["/app/burrow", "--config-dir", "/etc/burrow"]