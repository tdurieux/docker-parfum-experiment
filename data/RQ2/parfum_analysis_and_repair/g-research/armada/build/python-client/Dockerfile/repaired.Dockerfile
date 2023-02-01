ARG PYTHON_VERSION=3.9.12

FROM --platform=x86_64 python:${PYTHON_VERSION}-buster

RUN mkdir /proto

RUN pip install --no-cache-dir grpcio grpcio-tools poetry mypy-protobuf

ENTRYPOINT ["/bin/bash"]