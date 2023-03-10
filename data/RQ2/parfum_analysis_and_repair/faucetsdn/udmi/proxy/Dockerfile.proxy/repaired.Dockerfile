FROM ubuntu:focal

ENV AG="apt-get -qqy --no-install-recommends -o=Dpkg::Use-Pty=0"

WORKDIR /root

RUN $AG update && $AG install openjdk-11-jre-headless curl

ADD schema/ schema/
ADD proxy/bin bin/
ADD validator/build/libs/validator-1.0-SNAPSHOT-all.jar validator/build/libs/validator-1.0-SNAPSHOT-all.jar

CMD ["bin/run"]