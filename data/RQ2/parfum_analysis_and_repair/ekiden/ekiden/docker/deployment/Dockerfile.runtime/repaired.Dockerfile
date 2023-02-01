FROM tozd/sgx:ubuntu-xenial

ENV PATH="/ekiden/bin:${PATH}"

# install dependencies needed by learner contracts
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir numpy pandas protobuf xlrd

ADD . /ekiden
