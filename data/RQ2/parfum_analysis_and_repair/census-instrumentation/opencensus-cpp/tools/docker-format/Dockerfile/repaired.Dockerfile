FROM ubuntu:cosmic

RUN apt update && \
    apt install --no-install-recommends -y clang-format golang git python-pip && \
    go get -v github.com/bazelbuild/buildtools/buildifier && \
    pip install --no-cache-dir 'cmake_format>=0.5.2' && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/bash"]
