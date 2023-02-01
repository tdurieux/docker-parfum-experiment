ARG jmeter_ver=3.3

FROM gcr.io/shibuya-214807/alpine:3.10.2 AS jmeter
ARG jmeter_ver
ENV JMETER_VERSION=$jmeter_ver
RUN wget archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.zip
RUN unzip -qq apache-jmeter-${JMETER_VERSION}

FROM gcr.io/shibuya-214807/openjdk:8u212-jdk
ARG jmeter_ver
ENV JMETER_VERSION=$jmeter_ver
RUN mkdir /test-conf /test-result
COPY --from=jmeter /apache-jmeter-${JMETER_VERSION} /apache-jmeter-${JMETER_VERSION}
ADD ./build/shibuya-agent /usr/local/bin/shibuya-agent
COPY config.json config.json
ADD engines/jmeter/shibuya.properties /test-conf/shibuya.properties
ADD engines/jmeter/jmeter.sh /apache-jmeter-${JMETER_VERSION}/bin/jmeter
RUN mkdir /auth
ADD ./shibuya-gcp.json /auth/shibuya-gcp.json
ENV GOOGLE_APPLICATION_CREDENTIALS /auth/shibuya-gcp.json
CMD ["shibuya-agent"]