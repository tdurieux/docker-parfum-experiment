FROM daq/aardvark:latest

RUN $AG update && $AG install netcat

COPY misc/test_ping .

CMD ./test_ping
