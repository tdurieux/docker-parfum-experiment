FROM debian:10.4-slim

RUN apt-get update && \
        apt-get install --no-install-recommends --yes curl gnupg awscli && rm -rf /var/lib/apt/lists/*;

# Install helm
RUN curl -f https://helm.baltorepo.com/organization/signing.asc | apt-key add - && \
        apt-get install --no-install-recommends apt-transport-https --yes && \
        echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
        apt-get update && \
        apt-get install --no-install-recommends --yes helm && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /charts

WORKDIR /charts/
