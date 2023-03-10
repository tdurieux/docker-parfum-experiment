ARG STIM_IMAGE
FROM $STIM_IMAGE

RUN \
  set -x && \
  apk update && \
  apk -Uuv add bash curl zip jq groff less python py2-pip wget ca-certificates openssl git apache2-utils && \
  pip install --no-cache-dir awscli yq && \
  apk --purge -v del py2-pip && \
  rm /var/cache/apk/*

ENTRYPOINT ["/bin/bash", "-c"]
