FROM gliderlabs/alpine
ENTRYPOINT ["/home/flux/fluxd"]
RUN apk add --no-cache --update iptables \
  && rm -rf /var/cache/apk/*
COPY ./fluxd /home/flux/
