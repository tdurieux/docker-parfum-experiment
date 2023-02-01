FROM node:lts-buster-slim
WORKDIR /service
COPY . .
RUN npm install && npm cache clean --force;
RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  && rm -rf /var/lib/apt/lists/*
RUN curl -f -L -o /bin/opa https://github.com/open-policy-agent/opa/releases/download/v0.19.1/opa_linux_amd64
RUN chmod 755 /bin/opa
