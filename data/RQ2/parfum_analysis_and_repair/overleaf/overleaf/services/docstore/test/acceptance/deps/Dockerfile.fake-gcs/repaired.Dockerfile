FROM fsouza/fake-gcs-server:latest
RUN apk add --update --no-cache curl
COPY healthcheck.sh /healthcheck.sh
HEALTHCHECK --interval=1s --timeout=1s --retries=30 CMD /healthcheck.sh http://localhost:9090
CMD ["--port=9090", "--scheme=http"]