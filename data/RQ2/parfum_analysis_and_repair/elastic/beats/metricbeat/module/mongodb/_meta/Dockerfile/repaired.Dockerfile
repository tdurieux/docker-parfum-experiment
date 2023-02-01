ARG MONGODB_VERSION
FROM mongo:${MONGODB_VERSION}
RUN sed -i "/jessie-updates/d" /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
HEALTHCHECK --interval=1s --retries=90 CMD nc -z localhost 27017
