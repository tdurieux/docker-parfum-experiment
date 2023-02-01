FROM debian:jessie

ENV VERSION 0.9.3

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

ENV LUMINOS_URL https://github.com/xiam/luminos/releases/download/v$VERSION/luminos_linux_amd64.gz

RUN curl -f --silent -L ${LUMINOS_URL} | gzip -d > /bin/luminos

RUN chmod +x /bin/luminos

EXPOSE 9000

ENTRYPOINT [ "/bin/luminos" ]
