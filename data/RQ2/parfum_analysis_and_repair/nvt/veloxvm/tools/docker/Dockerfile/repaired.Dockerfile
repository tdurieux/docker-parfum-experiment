FROM ubuntu:latest

WORKDIR /velox
ADD . /velox

RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install bison clang clisp flex make && rm -rf /var/lib/apt/lists/*;
RUN make
RUN ./compile.sh
