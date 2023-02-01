# ----
FROM maven:3.8.3-openjdk-17-slim AS BUILD_IMAGE

WORKDIR /var/build/widoco

COPY . .

RUN mvn package && \
    mv ./JAR/widoco*.jar ./JAR/widoco.jar

# ----