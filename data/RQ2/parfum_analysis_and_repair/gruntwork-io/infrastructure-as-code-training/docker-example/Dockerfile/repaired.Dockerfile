# In this example, we use the 'latest' tag for simplicity. In production code, we recommend pinning to a more specific version.
# Details: https://vsupalov.com/docker-latest-tag/
FROM ubuntu:latest
LABEL maintainer="Yevgeniy Brikman <jim@gruntwork.io>"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -o Acquire::ForceIPv4=true -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g nodemon && npm cache clean --force;

WORKDIR /usr/src/app
COPY ./src ./

EXPOSE 8080
CMD ["nodemon", "server.js"]
