# Dockerfile for running DAML-on-Fabric as a Docker container
# used with build_ci.sh

FROM openjdk:8-jre

ARG SDK_VERSION
ENV SDK_VERSION=$SDK_VERSION

WORKDIR /daml-on-fabric
COPY daml-on-fabric.jar .
COPY config-local.yaml .
COPY get_jwks_token.sh .
COPY damlOnFabricStart.sh .
COPY ledger-api-test-tool.jar .

WORKDIR /daml-on-fabric/data
COPY data .

WORKDIR /daml-on-fabric/chaincode
COPY chaincode .

WORKDIR /daml-on-fabric

RUN java -jar ledger-api-test-tool.jar --extract

RUN curl -sSL https://get.daml.com/ | sh -s $SDK_VERSION
ENV PATH=/root/.daml/bin:$PATH

RUN apt-get update && apt-get install -y netcat

CMD /bin/bash -c "chmod +x damlOnFabricStart.sh && ./damlOnFabricStart.sh"
