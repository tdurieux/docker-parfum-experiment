FROM daqf/aardvark:latest

# Do this alone first so it can be re-used by other build files.

RUN $AG update && $AG install openjdk-11-jdk git maven

COPY usi/ usi/

RUN cd usi && mvn clean compile assembly:single

CMD ["./usi/start"]