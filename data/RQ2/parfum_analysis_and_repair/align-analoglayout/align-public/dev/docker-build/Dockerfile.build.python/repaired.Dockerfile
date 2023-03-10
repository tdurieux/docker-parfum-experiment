FROM ubuntu:18.04 as with_python

RUN apt-get update && apt-get install --no-install-recommends -yq vim git pkg-config python3 python3-pip python3-venv git build-essential graphviz libgraphviz-dev protobuf-compiler && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN \
    python3 -m venv sympy && \
    bash -c "source sympy/bin/activate; pip install pytest sympy networkx pygraphviz coverage pytest-cov protobuf"









