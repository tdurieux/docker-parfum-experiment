FROM ubuntu:latest
RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
COPY kvass /kvass
ENTRYPOINT ["/kvass"]