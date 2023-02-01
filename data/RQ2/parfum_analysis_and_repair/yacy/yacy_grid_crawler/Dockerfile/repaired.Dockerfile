## yacy_grid_crawler dockerfile
## examples:
# docker build -t yacy_grid_crawler .
# docker run -d --rm -p 8300:8300 --name yacy_grid_crawler yacy_grid_crawler
## Check if the service is running:
# curl http://localhost:8300/yacy/grid/mcp/info/status.json

# build app
FROM eclipse-temurin:8-jdk-alpine AS appbuilder
COPY ./ /app
WORKDIR /app
RUN ./gradlew clean shadowDistTar

# build dist
FROM eclipse-temurin:8-jre-alpine
LABEL maintainer="Michael Peter Christen <mc@yacy.net>"
ENV DEBIAN_FRONTEND noninteractive
ARG default_branch=master
COPY ./conf /app/conf/
COPY --from=appbuilder /app/build/libs/ ./app/build/libs/
WORKDIR /app
EXPOSE 8300

# for some weird reason the jar file is sometimes not named correctly