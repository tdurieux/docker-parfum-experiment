FROM daqf/aardvark2:latest


# Do this alone first so it can be re-used by other build files.
RUN $AG update && $AG install openjdk-11-jre

RUN $AG update && $AG install openjdk-11-jdk git tshark

COPY subset/security/ .

RUN sh enable_tls1.sh

RUN cd tlstest && ./gradlew build

CMD ["./test_tls"]