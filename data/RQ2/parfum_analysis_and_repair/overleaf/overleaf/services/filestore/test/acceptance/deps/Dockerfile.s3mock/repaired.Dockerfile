FROM adobe/s3mock
RUN apk add --update --no-cache curl
COPY healthcheck.sh /healthcheck.sh
HEALTHCHECK --interval=1s --timeout=1s --retries=30 CMD /healthcheck.sh http://localhost:9090