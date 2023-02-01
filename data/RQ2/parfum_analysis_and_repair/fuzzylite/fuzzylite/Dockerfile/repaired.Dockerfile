FROM fuzzylite/fuzzylite:6.0
MAINTAINER Juan Rada-Vilela <jcrada@fuzzylite.com>

ARG CXX_COMPILER=g++
ENV CXX_COMPILER ${CXX_COMPILER}

#update image if necessary, and install CXX compiler
RUN apt-get update && apt-get -y --no-install-recommends install ${CXX_COMPILER} && rm -rf /var/lib/apt/lists/*;

#Create and copy Docker's context into /build
RUN mkdir /build
ADD . /build
WORKDIR /build/fuzzylite
ENTRYPOINT [ "/build/fuzzylite/build.sh" ]