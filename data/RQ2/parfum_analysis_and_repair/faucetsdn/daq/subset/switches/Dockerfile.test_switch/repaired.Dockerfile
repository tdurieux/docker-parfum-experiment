FROM daqf/aardvark:latest

# Do this alone first so it can be re-used by other build files.
RUN $AG update && $AG install openjdk-11-jdk git

RUN $AG update && $AG install maven tcpdump

COPY subset/switches/ switches/
RUN mkdir -p switches/src/main/proto
COPY usi/src/main/proto/* switches/src/main/proto/

RUN cd switches && mvn clean compile assembly:single

CMD ["./switches/test_switch"]