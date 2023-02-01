FROM wslph/mule:3.9.0-ee as base

RUN apt-get update && apt-get -y --no-install-recommends install maven && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/apm-mule3-agent

COPY apm-mule3-agent /tmp/apm-mule3-agent

RUN mvn -P jar clean install

RUN mvn -P mule package
