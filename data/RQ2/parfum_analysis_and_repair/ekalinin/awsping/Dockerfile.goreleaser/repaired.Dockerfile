FROM gcr.io/distroless/base
COPY awsping /

ENTRYPOINT ["/awsping"]