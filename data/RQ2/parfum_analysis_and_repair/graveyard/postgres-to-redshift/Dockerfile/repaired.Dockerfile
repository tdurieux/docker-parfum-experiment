FROM debian:jessie
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl build-essential && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://github.com/Clever/gearcmd/releases/download/0.10.0/gearcmd-v0.10.0-linux-amd64.tar.gz | tar xz -C /usr/local/bin --strip-components 1

COPY bin/postgres-to-redshift /usr/local/bin/postgres-to-redshift
CMD ["gearcmd", "--name", "postgres-to-redshift", "--cmd", "/usr/local/bin/postgres-to-redshift"]
