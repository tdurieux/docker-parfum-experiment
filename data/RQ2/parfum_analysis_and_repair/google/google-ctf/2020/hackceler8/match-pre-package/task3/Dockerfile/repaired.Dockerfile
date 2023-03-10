FROM alpine:3
WORKDIR /usr/challenge
COPY ./task3.py .
RUN chmod a+rx ./task3.py
RUN apk add --no-cache socat
RUN apk add --no-cache python3
EXPOSE 7002
CMD while true; do socat tcp-l:7002,reuseaddr,fork 'exec:/usr/challenge/task3.py'; done
