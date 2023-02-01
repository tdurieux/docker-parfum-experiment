FROM ubuntu:18.04

RUN apt-get update && \
    apt-get -y --no-install-recommends install curl && \
    curl -f -sSL https://raw.githubusercontent.com/replicatedhq/replicated/master/install.sh | bash && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["replicated"]
