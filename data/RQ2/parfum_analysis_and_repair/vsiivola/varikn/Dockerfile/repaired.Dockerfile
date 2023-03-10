FROM ubuntu:groovy
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends\
                    g++ \
                    build-essential \
                    libboost-all-dev \
                    swig \
                    python-dev \
                    cmake && \
    apt-get autoclean && \
    apt-get autoremove && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
WORKDIR /code
COPY CMakeLists.txt CMakeLists.txt
COPY cmake cmake
COPY src src
COPY app app
COPY python-wrapper python-wrapper
COPY tests tests
