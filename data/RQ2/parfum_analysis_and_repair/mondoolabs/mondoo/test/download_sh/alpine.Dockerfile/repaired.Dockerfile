FROM alpine
RUN apk add --no-cache curl
RUN mkdir -p /trial
WORKDIR /root/trial
ADD download.sh /root/trial/download.sh
RUN sh /root/trial/download.sh
RUN /root/trial/mondoo version