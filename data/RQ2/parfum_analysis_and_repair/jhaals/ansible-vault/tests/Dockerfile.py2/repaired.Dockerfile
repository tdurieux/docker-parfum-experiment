FROM python:2.7-slim

ENV VAULT_VERSION 0.9.3

RUN apt-get update && \
    apt-get install --no-install-recommends unzip curl -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -LO https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip vault_${VAULT_VERSION}_linux_amd64.zip -d /bin

RUN pip install --no-cache-dir ansible flake8
COPY . ansible-vault
WORKDIR ./ansible-vault

CMD ["./tests/test.sh"]
