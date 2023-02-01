#
# Build
#
FROM apm-mule3-agent:1.3.0 as build

COPY . /tmp/component2

WORKDIR /tmp/component2

RUN mvn clean install

#
# Run
#