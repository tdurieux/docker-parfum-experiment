FROM java:8-jdk-alpine

ENV GATLING_VERSION 3.2.1

RUN apk --update --no-cache add \
	wget

RUN mkdir -p /opt/gatling

RUN cd /tmp && \
    wget -q -O gatling-${GATLING_VERSION}.zip https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/${GATLING_VERSION}/gatling-charts-highcharts-bundle-${GATLING_VERSION}-bundle.zip && \
    unzip gatling-${GATLING_VERSION}.zip && \
    mv /tmp/gatling-charts-highcharts-bundle-${GATLING_VERSION}/* /opt/gatling

ENV GATLING_HOME /opt/gatling
ENV PATH /opt/gatling/bin:${PATH}

ENTRYPOINT ["gatling.sh"]