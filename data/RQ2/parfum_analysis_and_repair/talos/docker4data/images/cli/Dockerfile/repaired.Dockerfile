FROM elasticsearch:1.4

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y openssl ca-certificates apt-transport-https python-pip git-core && rm -rf /var/lib/apt/lists/*;

COPY scripts /scripts
RUN /scripts/index.sh
