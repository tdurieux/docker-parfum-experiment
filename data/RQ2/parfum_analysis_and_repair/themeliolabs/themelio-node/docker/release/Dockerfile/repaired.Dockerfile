FROM debian:stable-slim

ARG themelio_node_version
ENV THEMELIO_NODE_VERSION ${themelio_node_version}

RUN apt update && apt -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

COPY themelio-node /usr/local/bin/themelio-node
RUN chmod +x /usr/local/bin/themelio-node
COPY run.sh /usr/local/bin/run.sh

EXPOSE 8080
EXPOSE 11814

ENTRYPOINT ["run.sh"]