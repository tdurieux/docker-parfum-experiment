FROM debian:buster-slim
LABEL maintainer "Devolutions Inc."

WORKDIR /opt/wayk

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

COPY devolutions-gateway .

EXPOSE 8080
EXPOSE 10256

ENTRYPOINT [ "./devolutions-gateway" ]
