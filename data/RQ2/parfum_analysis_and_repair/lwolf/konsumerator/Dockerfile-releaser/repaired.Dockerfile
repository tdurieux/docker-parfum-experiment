FROM gcr.io/distroless/static:latest
WORKDIR /
COPY konsumerator /
ENTRYPOINT ["/konsumerator"]