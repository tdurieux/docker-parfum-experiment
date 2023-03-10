# Base image
FROM openjdk:8-slim-buster

# Variables
ARG MY_ENV=develop
ARG UID=1001
ARG GID=1001
ENV MY_ENV=${MY_ENV}
ENV UID=${UID}
ENV GID=${GID}

# Install BUSTER packages
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Create group and user that will run the gateway
RUN groupadd -r --gid ${GID} app && useradd -r --uid ${UID} --gid ${GID} -s /sbin/nologin --home /gateway app

# Pull repository
RUN git clone -b ${MY_ENV} https://github.com/vicinityh2020/vicinity-gateway-api.git

# Move files to working dir
RUN mkdir gateway \
    && mkdir gateway/target \
    && mkdir gateway/config \
    && mkdir gateway/keystore \
    && mv vicinity-gateway-api/target/ogwapi-jar-with-dependencies.jar /gateway/target/ \
    && mv vicinity-gateway-api/config/* /gateway/config/ \
    && mv vicinity-gateway-api/keystore/genkeys.sh /gateway/keystore/ \
    && rm -rf vicinity-gateway-api
WORKDIR /gateway

# Change rights and user
RUN chmod 764 ./target/ogwapi-jar-with-dependencies.jar \
    && mkdir ./log/ \
    && chmod -R 777  ./log/ \
    && mkdir ./data/ \
    && chmod -R 777  ./data/ \
    && chown -R app:app /gateway \
    && chmod 764 ./config/GatewayConfig.xml \
    && chmod +x ./keystore/genkeys.sh
USER app

# Select port
EXPOSE  8181

# Start the gateway-api in docker container
CMD ["java", "-jar", "./target/ogwapi-jar-with-dependencies.jar"]
