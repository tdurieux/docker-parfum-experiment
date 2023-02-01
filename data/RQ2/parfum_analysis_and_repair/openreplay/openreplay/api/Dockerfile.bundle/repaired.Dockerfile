FROM python:3.9.12-slim
LABEL Maintainer="Rajesh Rajendran<rjshrjndrn@gmail.com>"
WORKDIR /work
COPY . .
COPY ../utilities ./utilities
RUN rm entrypoint.sh && rm .chalice/config.json
RUN mv entrypoint.bundle.sh entrypoint.sh && mv .chalice/config.bundle.json .chalice/config.json
RUN pip install --no-cache-dir -r requirements.txt -t ./vendor --upgrade
RUN pip install --no-cache-dir chalice==1.22.2
# Installing Nodejs
RUN apt update && apt install --no-install-recommends -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_12.x | bash - && \
    apt install --no-install-recommends -y nodejs && \
    apt remove --purge -y curl && \
    rm -rf /var/lib/apt/lists/* && \
    cd utilities && \
    npm install && npm cache clean --force;

# Add Tini
# Startup daemon
ENV TINI_VERSION v0.19.0
ARG envarg
ENV ENTERPRISE_BUILD ${envarg}
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]
CMD ./entrypoint.sh
