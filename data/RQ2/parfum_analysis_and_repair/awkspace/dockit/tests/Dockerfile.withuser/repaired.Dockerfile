FROM alpine

RUN adduser -u 1234 -D testuser
USER testuser