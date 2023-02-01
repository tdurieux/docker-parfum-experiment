#
# cunnie/sslip.io-ntp
#
# sslip.io NTP Dockerfile
#
# Much was from here: <https://goglides.io/manage-ntp-using-kubernetes/90/>

FROM alpine:3.11.3 AS sslip.io-ntp
LABEL org.opencontainers.image.authors="Brian Cunnie <brian.cunnie@gmail.com>"
RUN apk update
RUN apk add --no-cache openntpd
RUN mkdir -m 1777 /var/empty/tmp
ADD ./entrypoint-ntp.sh ./entrypoint-ntp.sh
RUN chmod 755 ./entrypoint-ntp.sh
ENTRYPOINT ["./entrypoint-ntp.sh"]
