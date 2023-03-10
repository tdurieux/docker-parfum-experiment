# This Docker file that includes building the source, does not currently work
# because the cohort-engine dependencies are not public, hence the "builder" image
# doesn't have access to them (it could if they were in say Mavern Central repo)
# and the build fails. We can use a simplified Docker file in the mean time that
# packages the pre-built JAR

# IBM Java SDK UBI is not available on public docker yet. Use regular
# base as builder until this is ready. For reference:
# https://github.com/ibmruntimes/ci.docker/tree/master/ibmjava/8/sdk/ubi-min

FROM ibmjava:8-sdk AS builder
LABEL maintainer="Luis A. Garcia at Alvearie"

WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

COPY pom.xml .
RUN mvn -N io.takari:maven:wrapper -Dmaven=3.5.0

COPY . /app
RUN ./mvnw install

ARG bx_dev_user=root
ARG bx_dev_userid=1000
RUN BX_DEV_USER=$bx_dev_user
RUN BX_DEV_USERID=$bx_dev_userid
RUN if [ $bx_dev_user != "root" ]; then useradd -ms /bin/bash -u $bx_dev_userid $bx_dev_user; fi

# Multi-stage build. New build stage that uses the UBI as the base image.

# In the short term, we are using the OpenJDK for UBI. Long term, we will use
# the IBM Java Small Footprint JVM (SFJ) for UBI, but that is not in public
# Docker at the moment.
# (https://github.com/ibmruntimes/ci.docker/tree/master/ibmjava/8/sfj/ubi-min)

FROM adoptopenjdk/openjdk8

# Copy over app from builder image into the runtime image.
RUN mkdir /opt/app
COPY --from=builder /app/target/cohort-service-1.0-SNAPSHOT.jar /opt/app/app.jar

ENTRYPOINT [ "sh", "-c", "java -jar /opt/app/app.jar" ]
