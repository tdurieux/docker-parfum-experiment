ARG DOCKER_VERSION="20.10.12"
FROM ubuntu
RUN apt-get update -y && apt-get install --no-install-recommends -y ca-certificates curl gnupg lsb-release unzip zip && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --batch --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update -y && apt-get install --no-install-recommends -y docker-ce-cli && rm -rf /var/lib/apt/lists/*;