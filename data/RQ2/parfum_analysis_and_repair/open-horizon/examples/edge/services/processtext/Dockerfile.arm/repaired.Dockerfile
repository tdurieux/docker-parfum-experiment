FROM alpine:latest

RUN apk add --no-cache mosquitto mosquitto-clients

WORKDIR /

COPY processtext.sh /

CMD ./processtext.sh