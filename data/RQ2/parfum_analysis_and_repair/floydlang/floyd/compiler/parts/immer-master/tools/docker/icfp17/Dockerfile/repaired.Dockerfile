FROM debian:stretch

MAINTAINER arximboldi

## install immer

RUN apt-get update && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/arximboldi/immer.git

## prepare test dependencies

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
            autoconf \
            automake \
            cmake \
            g++ \
            libboost-dev \
            libtool \
            make \
            pkg-config \
            -- && rm -rf /var/lib/apt/lists/*;

RUN mkdir /immer/build
WORKDIR /immer/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DCHECK_BENCHMARKS=1
RUN make deps
RUN make tests examples benchmarks

## prepare clojure dependencies

RUN apt-get update && \
    apt-get install --no-install-recommends -y default-jdk curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein \
         > /usr/local/bin/lein && \
    chmod +x /usr/local/bin/lein

WORKDIR /immer/tools/clojure
ENV LEIN_ROOT ok
RUN lein deps
RUN lein compile

## prepare scala dependencies

RUN apt-get update && \
    apt-get install --no-install-recommends -y gnupg2 apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN echo "deb https://dl.bintray.com/sbt/debian /" \
         > /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    apt-get update && \
    apt-get install --no-install-recommends -y sbt && rm -rf /var/lib/apt/lists/*;

WORKDIR /immer/tools/scala
RUN sbt compile

## prepare python dependencies

RUN apt-get update && \
    apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir \
        pytest-benchmark \
        pyrsistent

RUN pip install --no-cache-dir /immer

## add some editors

RUN apt-get update && \
    apt-get install --no-install-recommends -y emacs vim nano && rm -rf /var/lib/apt/lists/*;

## go to a useful working dir

WORKDIR /immer
