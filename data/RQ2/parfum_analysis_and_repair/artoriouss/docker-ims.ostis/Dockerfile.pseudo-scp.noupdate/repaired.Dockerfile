FROM artorious/ostis

ENV EXECUTABLE_NAME=wave
ENV TESTS_DIR=graph

RUN mkdir /ostis/code
COPY / /ostis/code