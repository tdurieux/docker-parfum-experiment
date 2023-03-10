FROM alpine:3.12.3
RUN apk upgrade --no-cache
COPY dist-static/gbpserver /usr/local/bin/

ENV KUBECONFIG=/kube/kube.yml
ENV GBP_SERVER_CONF=None
ENTRYPOINT exec /usr/local/bin/gbpserver -proxy-listen-port 443 --config-path $GBP_SERVER_CONF