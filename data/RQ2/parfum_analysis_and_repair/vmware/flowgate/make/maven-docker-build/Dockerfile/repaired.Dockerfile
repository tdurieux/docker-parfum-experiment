FROM maven:3.3.9-jdk-8

RUN mkdir /flowgate-build \
  && mkdir /log
VOLUME /flowgate-build /log
COPY build.sh /
RUN chmod o+x build.sh

WORKDIR /
ENTRYPOINT [ "bash", "build.sh" ]