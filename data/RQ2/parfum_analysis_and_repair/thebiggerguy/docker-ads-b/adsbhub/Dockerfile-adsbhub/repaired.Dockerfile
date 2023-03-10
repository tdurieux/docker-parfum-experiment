FROM multiarch/alpine:armhf-v3.9

RUN apk add --no-cache socat iputils

COPY adsbhub-client.sh /usr/local/bin/adsbhub-client
ENTRYPOINT ["adsbhub-client"]

# Metadata
ARG VCS_REF="Unknown"
LABEL maintainer="adsb@thebiggerguy.net" \
      org.label-schema.name="Docker ADS-B - adsbhub" \
      org.label-schema.description="Docker container for ADS-B - This is the adsbhub.org component" \
      org.label-schema.url="https://github.com/TheBiggerGuy/docker-ads-b" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.vcs-url="https://github.com/TheBiggerGuy/docker-ads-b" \
      org.label-schema.schema-version="1.0"