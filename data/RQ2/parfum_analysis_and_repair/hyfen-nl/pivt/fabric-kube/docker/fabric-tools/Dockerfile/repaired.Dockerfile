FROM raft/hl-fabric-tools:1.4.1

# install yq via pip
RUN curl -f "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && \
    python get-pip.py && \
    pip install --no-cache-dir yq

