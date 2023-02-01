FROM peternguyentr/node-java-chrome:latest

# Fix certificate issues
RUN apt-get update --no-install-recommends && \
    apt-get -y --no-install-recommends install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f; rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY . .

RUN npm install && npm cache clean --force;

CMD ["/app/docker/run-tests.sh"]
