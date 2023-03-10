FROM python:3.6

RUN apt-get update && apt-get install -y --no-install-recommends \ 
            vim libspatialindex-dev && rm -rf /var/lib/apt/lists/*

ARG oasis_ver=master
RUN pip install --no-cache-dir -v git+git://github.com/OasisLMF/OasisLMF.git@$oasis_ver#egg=oasislmf

WORKDIR /var/oasis
COPY ./docker/entrypoint_benchmark.py /usr/local/bin/benchmark.py

ENTRYPOINT ["/bin/bash", "-c", "benchmark.py \"$@\"", "--"]
