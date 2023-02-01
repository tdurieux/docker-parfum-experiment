# Dockerfile that builds frontend and backend, mainly used by the docker-compose files

# Vue Build Container
FROM node:16-buster as VUE
WORKDIR /frontend
COPY frontend .
RUN npm ci --legacy-peer-deps && npm run build

# Micronaut build
FROM maven:3-eclipse-temurin-17 as MAVEN

WORKDIR /home/maven

# Copy Files
COPY backend/pom.xml backend/formatter.xml ./
COPY backend/business-partner-agent ./business-partner-agent
COPY backend/business-partner-agent-core ./business-partner-agent-core
# Copy Vue App
COPY --from=VUE /frontend/dist ./business-partner-agent/src/main/resources/public

# Cache Maven Artefacts
RUN mvn dependency:go-offline || true

# Build .jar
RUN mvn clean package -DskipTests=true -Dspotbugs.skip=true -Dpmd.skip=true

# Runtime Container
FROM eclipse-temurin:17-jre-focal

# Setup rights for overwriting frontend runtime variables