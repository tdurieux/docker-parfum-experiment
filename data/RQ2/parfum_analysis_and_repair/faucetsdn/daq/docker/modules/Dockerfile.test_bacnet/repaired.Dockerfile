FROM daqf/aardvark:latest as bacnet_build

# Do this alone first so it can be re-used by other build files.
RUN $AG update && $AG install openjdk-8-jre

RUN $AG update && $AG install openjdk-8-jdk git

ENV BACHASH=94a794a756ee0d37c6a2e53e08747ee021415aa8

RUN bin/retry_cmd git clone https://github.com/grafnu/bacnet4j.git --single-branch \
  && cd bacnet4j && git reset --hard $BACHASH && ../bin/retry_cmd ./gradlew shadow

FROM daqf/aardvark:latest

RUN $AG update && $AG install openjdk-8-jre

COPY --from=bacnet_build /root/bacnet4j/*.jar bacnet4j/

COPY docker/include/bin/bacnet_discover .

CMD ["./bacnet_discover"]