FROM alpine as donor
RUN apk add --no-cache tzdata
FROM scratch
COPY mqtt2prometheus /mqtt2prometheus
# Copy CA Certificates
COPY --from=donor /etc/ssl/certs /etc/ssl/certs
# Copy Time Zone Data
COPY --from=donor /usr/share/zoneinfo /usr/share/zoneinfo
CMD ["/mqtt2prometheus"]
