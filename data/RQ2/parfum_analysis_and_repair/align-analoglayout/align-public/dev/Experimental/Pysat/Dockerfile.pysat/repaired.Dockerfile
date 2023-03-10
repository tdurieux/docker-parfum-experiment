FROM ubuntu:18.04 as pysat_image

RUN apt-get update && apt-get install --no-install-recommends -yq pkg-config python3 python3-pip python3-venv git build-essential graphviz libgraphviz-dev protobuf-compiler curl zlib1g-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN \
    python3 -m venv general && \
    bash -c "source general/bin/activate && pip install --upgrade pip && pip install wheel && pip install pytest coverage pytest-cov coverage-badge codacy-coverage hypothesis networkx python-sat==0.1.3.dev25"



