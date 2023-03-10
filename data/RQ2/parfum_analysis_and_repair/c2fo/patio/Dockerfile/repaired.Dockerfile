FROM node:12

ENV DEBIAN_FRONTEND=noninteractive

# Install netcat, and mysql/postgres so we can create additional DBs
RUN apt-get update && \
    apt-get -y --no-install-recommends install netcat build-essential postgresql mysql-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /patio
COPY package.json .
RUN npm install -g grunt-cli && \
    npm install && npm cache clean --force;
COPY . .

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["test"]
