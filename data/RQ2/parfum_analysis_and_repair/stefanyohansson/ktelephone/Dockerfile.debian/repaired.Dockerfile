FROM debian:unstable
RUN apt update -y && apt install --no-install-recommends -y cmake g++ qtbase5-dev qtmultimedia5-dev libpjproject-dev && rm -rf /var/lib/apt/lists/*;
ADD . /usr/src/ktelephone
WORKDIR /usr/src/ktelephone
RUN mkdir -p build/
WORKDIR /usr/src/ktelephone/build
RUN cmake ..
RUN make
