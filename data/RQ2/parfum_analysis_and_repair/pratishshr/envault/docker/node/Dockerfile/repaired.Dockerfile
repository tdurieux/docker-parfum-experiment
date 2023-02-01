FROM node:12-stretch-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl unzip \
    && curl -sf "https://raw.githubusercontent.com/pratishshr/envault/master/install.sh" | sh \
    && curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install && rm -rf /var/lib/apt/lists/*;




