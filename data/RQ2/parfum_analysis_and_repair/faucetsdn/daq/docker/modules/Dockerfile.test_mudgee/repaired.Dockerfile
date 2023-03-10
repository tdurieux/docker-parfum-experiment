FROM daqf/aardvark:latest

# Do this alone first so it can be re-used by other build files.
RUN $AG update && $AG install openjdk-11-jre

RUN $AG update && $AG install openjdk-11-jdk git

RUN $AG update && $AG install maven tcpdump

WORKDIR /root/

RUN bin/retry_cmd git clone https://github.com/grafnu/mudgee.git --single-branch --depth 1

RUN cd mudgee && ../bin/retry_cmd mvn clean install

COPY docker/include/bin/test_mudgee .

CMD ./test_mudgee