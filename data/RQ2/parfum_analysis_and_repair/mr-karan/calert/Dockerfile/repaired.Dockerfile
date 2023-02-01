FROM ubuntu:20.04
RUN apt-get -y update && apt install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY calert.bin .
COPY static/ /app/static/
COPY config.sample.toml config.toml
ENTRYPOINT [ "./calert.bin" ]
