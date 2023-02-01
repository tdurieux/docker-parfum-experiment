ARG SOURCE_DOCKER_HUB
ARG FULL_GRAALVM_VERSION
FROM ${SOURCE_DOCKER_HUB}:${FULL_GRAALVM_VERSION} as graalvm-jdk-image

FROM buildpack-deps:stretch-scm

# Install smaller utilities needed during building of image in the slim image
RUN echo; echo "--- Installing wget, curl, vim, unzip in the slim image"; echo
RUN apt-get update && \
    apt-get install -yq --no-install-recommends unzip git && rm -rf /var/lib/apt/lists/*;

ARG GRAALVM_HOME

# Install and setup GraalVM
COPY --from=graalvm-jdk-image /opt/graalvm-* ${GRAALVM_HOME}

ENV JAVA_HOME=${GRAALVM_HOME}
ENV PATH=${GRAALVM_HOME}/bin:${PATH}
RUN echo; echo "JAVA_HOME=${JAVA_HOME}"; echo
RUN echo; echo " --- GraalVM version (runtime)"; java -version; echo

# Build and Install micronaut
RUN cd /tmp; git clone https://github.com/micronaut-projects/micronaut-starter.git
RUN cd /tmp/micronaut-starter; ./gradlew micronaut-cli:assembleDist
RUN mkdir -p ~/.micronaut; unzip /tmp/micronaut-starter/starter-cli/build/distributions/micronaut-cli-*.zip -d ~/.micronaut
ENV MICRONAUT_HOME="/root/.micronaut/micronaut-cli"
RUN OLD_NAME=$(ls ~/.micronaut); mv ~/.micronaut/${OLD_NAME} ${MICRONAUT_HOME}
RUN echo "MICRONAUT_HOME=${MICRONAUT_HOME}";                       \
    ls -lash ${MICRONAUT_HOME}/bin;                                \
    echo; echo "micronaut version:"; ${MICRONAUT_HOME}/bin/mn --version; echo

LABEL maintainer="GraalVM team"
LABEL git_repo="https://github.com/micronaut-projects/micronaut-starter.git"
LABEL graalvm_version=${FULL_GRAALVM_VERSION}
LABEL version=${FULL_GRAALVM_VERSION}