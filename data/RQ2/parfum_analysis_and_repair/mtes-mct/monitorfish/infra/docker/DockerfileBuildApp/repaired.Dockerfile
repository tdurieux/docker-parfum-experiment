#####################
# Multi stage build #
#####################

ARG GITHUB_SHA=NO_COMMIT
ARG VERSION=NO_VERSION

########################################
# Build monitorfish backend with maven #
########################################
FROM maven:3.6.0-jdk-11-slim as buildBack

ARG GITHUB_SHA
ARG VERSION

WORKDIR /tmp/
COPY backend/pom.xml /tmp/pom.xml
RUN mvn dependency:go-offline -B

COPY backend/ /tmp/
COPY backend/pom.xml /tmp/POM_WITH_ENV_VARS
RUN sed -e 's/COMMIT_TO_CHANGE/${GITHUB_SHA}/' \
        -e 's/VERSION_TO_CHANGE/${VERSION}/' \
        POM_WITH_ENV_VARS > pom.xml

RUN mvn clean package -DskipTests=true

###########################
# Build frontend with npm #
###########################
FROM ubuntu:18.04 as buildFront

ENV DEBIAN_FRONTEND=noninteractive

ARG ENV_PROFILE
ENV REACT_APP_ENV $ENV_PROFILE

RUN echo ${REACT_APP_ENV}

RUN apt-get update &&\
    apt-get install  --no-install-recommends -y \
                   curl \
                   zip \
                   unzip \
                   ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
USER root

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash && \
 apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

COPY frontend/ /tmp/frontend/
COPY infra/ /tmp/infra/
WORKDIR /tmp/frontend

# Files are expected to be in /tmp/frontend/dist/monitorfish-frontend
RUN npm install && \
    npm run build && npm cache clean --force;

######################
# Create final image #
######################
# There is no more JRE with Java 11 : https://stackoverflow.com/a/53733414
FROM azul/zulu-openjdk-alpine:11

ARG VERSION
ENV VERSION $VERSION

ARG ENV_PROFILE
ENV ENV_PROFILE $ENV_PROFILE

ENV REACT_APP_ENV $ENV_PROFILE
ENV ENV_DB_URL=

# Add bash
RUN apk add --no-cache bash

RUN adduser -D monitorfish
USER monitorfish

EXPOSE 8880
EXPOSE 5000
EXPOSE 5001
WORKDIR /home/monitorfish

ENV JAVA_TOOL_OPTIONS "-Dcom.sun.management.jmxremote.ssl=false \
 -Dcom.sun.management.jmxremote.authenticate=false \
 -Dcom.sun.management.jmxremote.port=5000 \
 -Dcom.sun.management.jmxremote.rmi.port=5001 \
 -Dcom.sun.management.jmxremote.registry.ssl=false \
 -Dcom.sun.management.jmxremote.host=0.0.0.0 \
 -Djava.rmi.server.hostname=0.0.0.0"

# Copy files for the back
COPY --from=buildBack /tmp/target/monitorfish-${VERSION}-exec.jar /home/monitorfish
COPY infra/configurations /home/monitorfish/configurations/

USER monitorfish
# Copy files for the front
RUN mkdir /home/monitorfish/public
COPY --from=buildFront /tmp/frontend/build /home/monitorfish/public/
COPY --from=buildFront /tmp/infra/docker/env.sh /home/monitorfish/

# Add logs folder to be mounted as volume
RUN mkdir /home/monitorfish/logs

# Set up environement variable that define the root folder use for serving static files
# It must point to the front (React) files
ENV STATIC_FILES_PATH /home/monitorfish/public

# Default profile is for local. Can be overiden at start : docker run -e "SPRING_PROFILES_ACTIVE=prod"
ENV SPRING_PROFILES_ACTIVE ${ENV_PROFILE}

RUN echo ${ENV_PROFILE}

USER root
RUN chown monitorfish /home/monitorfish/env.sh
RUN chmod +x /home/monitorfish/env.sh
USER monitorfish

ENV REACT_APP_GEOSERVER_LOCAL_URL=

ENTRYPOINT ["/home/monitorfish/env.sh"]

CMD exec java -Dspring.config.additional-location="/home/monitorfish/configurations/" -jar "monitorfish-${VERSION}-exec.jar"
