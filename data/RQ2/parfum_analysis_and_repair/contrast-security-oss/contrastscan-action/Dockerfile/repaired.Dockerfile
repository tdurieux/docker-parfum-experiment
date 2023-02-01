# Container image that runs your code
FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y curl \
    && curl -f --location -O https://pkg.contrastsecurity.com/artifactory/cli/1.0.6/linux/contrast \
    && chmod +x contrast && mv contrast /usr/bin && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

