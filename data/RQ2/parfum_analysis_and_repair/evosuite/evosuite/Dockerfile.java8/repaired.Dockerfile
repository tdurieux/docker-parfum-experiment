# Container image for building the project
FROM maven:3-openjdk-8 as build
LABEL maintainer="Mitchell Olsthoorn"

# Parameter for skipping the tests in the build process
ARG SKIP_TESTS=true

WORKDIR /build

# Copy files and directories needed for building
COPY pom.xml ./
COPY shaded ./shaded/
COPY standalone_runtime ./standalone_runtime/
COPY plugins ./plugins/
COPY runtime ./runtime/
COPY client ./client/
COPY master ./master/

# Build the project
# The -e flag is to show errors and -B to run in non-interactive aka “batch” mode
# Lastly, make build-artifact naming version-independent
RUN mvn -e -B package -DskipTests=${SKIP_TESTS} && \
    mkdir -p /build/bin && \
    mv master/target/evosuite-master-*-tests.jar bin/evosuite-tests.jar && \
    mv master/target/evosuite-master-*.jar bin/evosuite.jar

# Container image for running EvoSuite
FROM openjdk:8-jdk

WORKDIR /evosuite
VOLUME /evosuite

# Copy the evosuite jar from the builder to this container
COPY --from=build /build/bin /evosuite-bin

# The executable is evosuite
ENTRYPOINT ["java", "-jar", "/evosuite-bin/evosuite.jar"]

# The default argument is the help menu
# This can be overidden on the command line