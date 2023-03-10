#
# Final stage
#
FROM alpine:3.7
LABEL maintainer "Abiola Ibrahim <abiola89@gmail.com>"

LABEL caddy_version="0.10.11"

RUN apk add --no-cache openssh-client git openssl wget

# install caddy
RUN (wget -qO- https://caddyserver.com/download/linux/amd64\?plugins\=http.cgi,http.cors,http.expires,http.filter,http.git,http.jwt,http.locale,http.login,http.prometheus,http.ratelimit,http.realip,http.reauth,tls.dns.dnspod\&license\=personal | tar xzvC /tmp) && cp /tmp/caddy /usr/bin/caddy

# validate install