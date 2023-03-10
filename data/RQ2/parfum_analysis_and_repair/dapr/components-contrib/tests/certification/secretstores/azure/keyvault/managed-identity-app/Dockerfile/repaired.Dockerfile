FROM ubuntu:latest
COPY . /app
WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends wget curl --yes && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash
RUN dapr init --slim
ENV AzureKeyVaultName=dapr2-conf-test-kv
ENTRYPOINT [ "bash", "startup.sh" ]