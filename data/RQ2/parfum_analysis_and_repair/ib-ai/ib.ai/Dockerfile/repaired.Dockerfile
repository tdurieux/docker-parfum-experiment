# Using maven base image for building with maven.
FROM maven:3.8.1-openjdk-11 AS builder

LABEL "repository"="https://github.com/ib-ai/IB.ai/"
LABEL "homepage"="https://discord.gg/IBO/"
LABEL "maintainer"="Jarred Vardy <vardy@riseup.net>"

WORKDIR /IB.ai/

# Resolve maven dependencies
COPY pom.xml .
COPY checkstyle.xml .
RUN mvn dependency:go-offline

# Build from source into ./target/*.jar
COPY src ./src
# We don't want checkstyle in development...
RUN mvn -e -B package -Dcheckstyle.skip

# Using Java JDK 10 base image
FROM openjdk:10

WORKDIR /IB.ai/

# Copying maven dependencies from builder image to prevent re-downloads
COPY --from=builder /root/.m2 /root/.m2

# Add language files
COPY lang ./lang

# Copying artifacts from maven (builder) build stage
COPY --from=builder /IB.ai/pom.xml .
COPY --from=builder /IB.ai/target/ ./target

# Running bot. Uses version from pom.xml to call artifact file name.