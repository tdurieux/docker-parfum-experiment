FROM alpine:3.10

# Install the cloudposse alpine repository
ADD https://apk.cloudposse.com/ops@cloudposse.com.rsa.pub /etc/apk/keys/
RUN echo "https://apk.cloudposse.com/3.10/vendor" >> /etc/apk/repositories
RUN echo "https://alpine.global.ssl.fastly.net/alpine/edge/testing" >> /etc/apk/repositories
RUN echo "https://alpine.global.ssl.fastly.net/alpine/edge/community" >> /etc/apk/repositories

RUN apk update
RUN apk add --no-cache make curl alpine-sdk shadow bash jq
RUN echo "auth       sufficient   pam_shells.so" > /etc/pam.d/chsh
