FROM ubuntu:18.10
MAINTAINER Amit Bakshi <ambakshi@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -yq && apt-get install --no-install-recommends -yq \
    build-essential \
    gcc \
    g++ \
    cmake \
    make \
    libpthread-stubs0-dev && rm -rf /var/lib/apt/lists/*;
ADD . /app
WORKDIR /app/build
RUN cmake -G 'Unix Makefiles' ..
RUN /usr/bin/make -j8
RUN ./pbrt_test


