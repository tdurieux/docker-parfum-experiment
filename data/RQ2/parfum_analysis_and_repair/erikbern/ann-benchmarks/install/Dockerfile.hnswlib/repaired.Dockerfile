FROM ann-benchmarks

RUN apt-get install --no-install-recommends -y python-setuptools python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pybind11 numpy setuptools
RUN git clone https://github.com/nmslib/hnsw.git;cd hnsw; git checkout denorm

RUN cd hnsw/python_bindings; python3 setup.py install

RUN python3 -c 'import hnswlib'

