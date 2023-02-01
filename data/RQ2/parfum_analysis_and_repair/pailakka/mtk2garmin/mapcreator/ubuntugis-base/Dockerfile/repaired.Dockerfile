FROM quay.io/azavea/openjdk-gdal:3.1-jdk11-slim

RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt update && \
    apt install --no-install-recommends -y git p7zip-full nodejs default-jdk maven && \
    npm install -g svgo && \
    apt clean && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;