# Pin to Spark 2.x for Scala 2.11 (https://issues.apache.org/jira/browse/LIVY-423)
FROM datamechanics/spark:2.4.7-hadoop-3.1.0-java-8-scala-2.11-python-3.7-latest

# Use root user for development. This shouldn't be used in production.
USER 0

# ----------
# Setup Python and Livy/Spark Deps
#
# Livy Requires:
# - mvn (from maven package or maven3 tarball)
# - openjdk-8-jdk (or Oracle JDK 8)
# - Python 2.7+
# - R 3.x
RUN apt-get update && apt-get install -yq --no-install-recommends --force-yes \
    curl \
    git \
    python3 python3-setuptools python3-venv python3-pip \
    r-base \
    r-base-core && \
    rm -rf /var/lib/apt/lists/*

ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

# ----------
# Build Livy
# ----------
ARG LIVY_VERSION=0.7.1-incubating
ENV LIVY_HOME /usr/livy
ENV LIVY_CONF_DIR "${LIVY_HOME}/conf"
ENV LIVY_PORT 8998

RUN curl -f --progress-bar -L --retry 3 \
    "https://archive.apache.org/dist/incubator/livy/${LIVY_VERSION}/apache-livy-${LIVY_VERSION}-bin.zip" \
    -o "./apache-livy-${LIVY_VERSION}-bin.zip" \
  && unzip -qq "./apache-livy-${LIVY_VERSION}-bin.zip" -d /usr \
  && mv "/usr/apache-livy-${LIVY_VERSION}-bin" "${LIVY_HOME}" \
  && rm -rf "./apache-livy-${LIVY_VERSION}-bin.zip" \
  && mkdir "${LIVY_HOME}/logs" \
  && chown -R root:root "${LIVY_HOME}"

EXPOSE 8998

HEALTHCHECK CMD curl -f "http://host.docker.internal:${LIVY_PORT}/" || exit 1

CMD ${LIVY_HOME}/bin/livy-server
