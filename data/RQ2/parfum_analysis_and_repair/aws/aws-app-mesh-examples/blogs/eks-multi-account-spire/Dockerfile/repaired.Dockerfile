FROM gcr.io/spiffe-io/spire-server:1.0.1
RUN apk add --no-cache --update-cache python3
RUN apk -Uuv add groff less python3 py-pip \
    && pip install --no-cache-dir awscli \
    && rm /var/cache/apk/*
CMD []