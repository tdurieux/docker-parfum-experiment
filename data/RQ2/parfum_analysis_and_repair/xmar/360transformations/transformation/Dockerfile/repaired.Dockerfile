FROM debian:buster as builder
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y ffmpeg libopencv-dev libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake libgomp1 && rm -rf /var/lib/apt/lists/*;
WORKDIR /tmp
COPY . /tmp
RUN rm -rf build && mkdir build
WORKDIR /tmp/build
RUN cmake ..
RUN make

FROM debian:buster as worker
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y ffmpeg libopencv-dev libboost-all-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/trans360
COPY --from=builder /tmp/build/MainProject/trans /bin
