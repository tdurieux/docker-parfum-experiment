# --- Build ---
FROM openjdk:8-jdk-alpine as BUILD

COPY gradle ./gradle
COPY gradlew .

# Layer to download gradle
RUN ./gradlew

COPY build.gradle .

# Download dependencies
RUN ./gradlew getDependencies -x test --continue

COPY src ./src

# Execute build
RUN ./gradlew clean build -x test

# --- Release ---