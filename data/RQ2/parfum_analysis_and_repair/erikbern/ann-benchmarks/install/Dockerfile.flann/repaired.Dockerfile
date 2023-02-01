FROM ann-benchmarks

RUN apt-get update && apt-get install --no-install-recommends -y cmake pkg-config liblz4-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/mariusmuja/flann
RUN mkdir flann/build
RUN cd flann/build && cmake ..
RUN cd flann/build && make -j4
RUN cd flann/build && make install
RUN pip3 install --no-cache-dir sklearn
RUN python3 -c 'import pyflann'
