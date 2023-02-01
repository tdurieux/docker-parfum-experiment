FROM node:12-slim

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y git && \
  apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh"]
