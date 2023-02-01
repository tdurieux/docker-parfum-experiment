## Build environment.
# Java 11, Scala 2.12.13, SBT 1.5.0 included.
FROM hseeberger/scala-sbt:11.0.14.1-oraclelinux8_1.6.2_2.13.8 as build
# Build application inside /app
WORKDIR /app

# Install git
RUN microdnf update -y && microdnf install git -y --nodocs --refresh

# Copy all application files
COPY . ./
# Build to /app/target/universal/rdfshape.zip
RUN ["sbt", "Universal / packageBin"]

## Prod environment.
FROM adoptopenjdk/openjdk12:jre-12.0.2_10-ubuntu as prod
LABEL org.opencontainers.image.source="https://github.com/weso/rdfshape-api"
WORKDIR /app

# Copy zip with universal executable
COPY --from=build /app/target/universal/rdfshape.zip .

# Download required programs dependencies. Unzip binaries.
RUN apt -qq -y update && apt -qq -y upgrade && \
    apt -qq -y install unzip graphviz && \
    unzip -q rdfshape.zip && \
    rm rdfshape.zip

# Add rdfshape to path
ENV PATH="/app/rdfshape/bin:${PATH}"

# Run
# Port for the app to run
ENV PORT=8080
EXPOSE $PORT
# Timeout for streaming validations (seconds)
ENV STREAM_TIMEOUT=40
# Non-priviledged user to run the app
RUN addgroup --system rdfshape && adduser --system --shell /bin/false --ingroup rdfshape rdfshape
RUN chown -R rdfshape:rdfshape /app
USER rdfshape

# JVM settings to allow connection to DB
ENV SSL_FIX="-Djdk.tls.client.protocols=TLSv1.2"

# Define commands to launch RDFShape
ENV HTTPS_CLI_ARG="--https"
ENV RDFSHAPE_CMD_HTTP="rdfshape $SSL_FIX --port $PORT --stream-timeout $STREAM_TIMEOUT -s"
ENV RDFSHAPE_CMD_HTTPS="$RDFSHAPE_CMD_HTTP $HTTPS_CLI_ARG"

CMD bash -c "if [[ ! -z '$USE_HTTPS' ]]; then $RDFSHAPE_CMD_HTTPS; else $RDFSHAPE_CMD_HTTP; fi"