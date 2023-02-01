FROM arm32v7/debian:stretch

RUN apt-get update && apt-get install --no-install-recommends -y cmake liblog4cpp5-dev libv4l-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/mpromonet/v4l2rtspserver.git && \
    cd v4l2rtspserver/ && \
    cmake . && \
    make && \
    make install
