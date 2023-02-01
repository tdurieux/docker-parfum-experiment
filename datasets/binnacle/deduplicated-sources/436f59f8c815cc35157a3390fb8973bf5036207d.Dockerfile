FROM debian:stretch-slim
ENV VERSION 0.2.2
WORKDIR /app
RUN apt-get update && apt-get install -y curl openssl && \
    curl -L -o pact-stub-server.gz https://github.com/uglyog/pact-stub-server/releases/download/v$VERSION/pact-stub-server-linux-x86_64-$VERSION.gz && \
    gunzip pact-stub-server.gz && \
    chmod +x pact-stub-server && \
    apt-get purge -y curl && apt-get -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/*
EXPOSE 8080
ENTRYPOINT ["./pact-stub-server"]
CMD ["--help"]
