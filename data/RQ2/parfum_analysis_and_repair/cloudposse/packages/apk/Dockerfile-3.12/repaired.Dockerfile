FROM alpine:3.12

ENV LC_ALL=C.UTF-8
ENV PS1="(apk) \w \$ "

# Install the cloudposse alpine repository
ADD https://apk.cloudposse.com/ops@cloudposse.com.rsa.pub /etc/apk/keys/
RUN echo "https://apk.cloudposse.com/3.12/vendor" >> /etc/apk/repositories
RUN echo "https://alpine.global.ssl.fastly.net/alpine/edge/testing" >> /etc/apk/repositories
RUN echo "https://alpine.global.ssl.fastly.net/alpine/edge/community" >> /etc/apk/repositories

RUN apk update && \
    apk add --no-cache make curl alpine-sdk shadow bash jq sudo go

RUN echo "auth       sufficient   pam_shells.so" > /etc/pam.d/chsh
