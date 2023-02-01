#FROM fefrei/carl:19.01
FROM smtrat/carl:latest
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    gcc-8-base \
    openjdk-8-jre \
    uuid-dev \
    pkg-config \
    libboost-dev && rm -rf /var/lib/apt/lists/*;
COPY / /root/hypro/
RUN cd /root/hypro && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release ..
RUN cd /root/hypro/build && make resources -j`nproc`
RUN cd /root/hypro/build && make -j`nproc`
