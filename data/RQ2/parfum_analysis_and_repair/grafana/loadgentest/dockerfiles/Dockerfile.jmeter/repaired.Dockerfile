FROM java:8-jdk-alpine

ENV JMETER_VERSION 5.1.1

RUN apk --update --no-cache add \
	wget

RUN cd /bin && \
    wget -O - 'https://apache.mirrors.spacedump.net/jmeter/binaries/apache-jmeter-'${JMETER_VERSION}'.tgz' | tar -zxf -

ENV PATH "/bin/apache-jmeter-${JMETER_VERSION}/bin:${PATH}"
