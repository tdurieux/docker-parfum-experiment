FROM ann-benchmarks

RUN apt-get update && apt-get install --no-install-recommends -y git cmake g++ python3 python3-setuptools python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir wheel pybind11
RUN git clone https://github.com/yahoojapan/ngt.git
RUN mkdir -p ngt/build
RUN cd ngt/build && cmake ..
RUN cd ngt/build && make && make install
RUN ldconfig
RUN cd ngt/python && python3 setup.py bdist_wheel
RUN pip3 install --no-cache-dir ngt/python/dist/ngt-*-linux_x86_64.whl

