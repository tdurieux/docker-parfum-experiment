FROM alpine:latest

ENV http_proxy $proxy
ENV https_proxy $proxy

RUN if [ -n $dns ];\
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
    apk update && apk upgrade && apk add --no-cache wget chromium ca-certificates

ADD certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN if [ -n $dns ];\
    then echo "nameserver $dns" >> /etc/resolv.conf;\
    fi; \
    wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip -O aquatone.zip && \
    unzip aquatone.zip && \
    mv aquatone /usr/bin/

RUN mkdir -p $output/aquatone-flyover

WORKDIR $output/aquatone-flyover
ENTRYPOINT cat $infile | aquatone -chrome-path /usr/bin/chromium-browser