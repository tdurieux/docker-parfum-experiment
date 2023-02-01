FROM ann-benchmarks

RUN apt-get install --no-install-recommends -y libhdf5-openmpi-dev cython && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir nearpy bitarray redis sklearn
RUN python3 -c 'import nearpy'