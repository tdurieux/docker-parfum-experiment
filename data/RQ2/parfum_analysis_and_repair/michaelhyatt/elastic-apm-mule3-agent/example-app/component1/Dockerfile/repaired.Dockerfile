#
# Build
#
FROM apm-mule3-agent:1.3.0 as build

COPY . /tmp/component1

WORKDIR /tmp/component1

RUN mvn clean install

#
# Run
#