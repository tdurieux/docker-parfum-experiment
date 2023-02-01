# A docker file for scripts/make/build-docker.sh.

FROM alpine:3.16

ARG BUILD_DATE
ARG VERSION
ARG VCS_REF

LABEL\
	maintainer="AdGuard Team <devteam@adguard.com>" \
	org.opencontainers.image.authors="AdGuard Team <devteam@adguard.com>" \
	org.opencontainers.image.created=$BUILD_DATE \
	org.opencontainers.image.description="Network-wide ads & trackers blocking DNS server" \
	org.opencontainers.image.documentation="https://github.com/AdguardTeam/AdGuardHome/wiki/" \
	org.opencontainers.image.licenses="GPL-3.0" \
	org.opencontainers.image.revision=$VCS_REF \
	org.opencontainers.image.source="https://github.com/AdguardTeam/AdGuardHome" \
	org.opencontainers.image.title="AdGuard Home" \
	org.opencontainers.image.url="https://adguard.com/en/adguard-home/overview.html" \
	org.opencontainers.image.vendor="AdGuard" \
	org.opencontainers.image.version=$VERSION

# Update certificates.
RUN apk --no-cache add ca-certificates libcap tzdata && \
	mkdir -p /opt/adguardhome/conf /opt/adguardhome/work && \
	chown -R nobody: /opt/adguardhome

ARG DIST_DIR
ARG TARGETARCH
ARG TARGETOS
ARG TARGETVARIANT

COPY --chown=nobody:nogroup\
	./${DIST_DIR}/docker/AdGuardHome_${TARGETOS}_${TARGETARCH}_${TARGETVARIANT}\
	/opt/adguardhome/AdGuardHome

RUN setcap 'cap_net_bind_service=+eip' /opt/adguardhome/AdGuardHome

# 53     : TCP, UDP : DNS
# 67     :      UDP : DHCP (server)
# 68     :      UDP : DHCP (client)
# 80     : TCP      : HTTP (main)
# 443    : TCP, UDP : HTTPS, DNS-over-HTTPS (incl. HTTP/3), DNSCrypt (main)
# 784    :      UDP : DNS-over-QUIC (experimental)
# 853    : TCP, UDP : DNS-over-TLS, DNS-over-QUIC
# 3000   : TCP, UDP : HTTP(S) (alt, incl. HTTP/3)
# 3001   : TCP, UDP : HTTP(S) (beta, incl. HTTP/3)
# 5443   : TCP, UDP : DNSCrypt (alt)
# 6060   : TCP      : HTTP (pprof)
# 8853   :      UDP : DNS-over-QUIC (experimental)