# SSH tunnel to informix dev database
# usage: docker run -d --name=informixdev-tunnel -v /Users/james/ssh:/ssh -p 2020:2020 -t informixdev-tunnel
FROM gliderlabs/alpine:3.2

MAINTAINER james@appirio.com

RUN apk-install openssh-client

#VOLUME ["/ssh"]

#EXPOSE 2020