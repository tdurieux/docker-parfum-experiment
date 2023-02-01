FROM amd64/ubuntu:latest

WORKDIR /usr/src/app
RUN apt-get update && apt-get install --no-install-recommends -y \
    libssl-dev \
    curl \
    jq && rm -rf /var/lib/apt/lists/*;

COPY install.sh .
RUN ./install.sh

STOPSIGNAL SIGINT

CMD [ "/usr/src/app/router", "-c", "/etc/config/configuration.yaml", "-s", "/etc/config/supergraph.graphql", "--log", "info" ]
