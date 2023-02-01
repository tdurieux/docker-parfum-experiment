#
# Dockerfile for Service B
#

FROM java:8

MAINTAINER Oreste Luci

# Install netcat
RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

VOLUME /tmp

WORKDIR /service-a

ADD target/service-a.jar service-a.jar

RUN bash -c 'touch /service-a.jar'

ADD run.sh run.sh
RUN chmod 744 run.sh

CMD ["./run.sh","service-a.jar"]