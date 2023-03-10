FROM ngraph_base_cpu

WORKDIR /root/ngraph-test

RUN apt-get install --no-install-recommends -y pandoc && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/ngraph-test
ADD . /root/ngraph-test
RUN make doc_prepare

# add chown_files script
WORKDIR /root/ngraph-test
ADD contrib/docker/chown_files.sh /tmp/chown_files.sh
