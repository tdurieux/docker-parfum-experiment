FROM swift:5.2
WORKDIR /code
ADD . .
RUN cp flatc_debian_stretch flatc
WORKDIR /code/tests
RUN swift --version
WORKDIR /code/tests/FlatBuffers.Test.Swift
RUN sh SwiftTest.sh