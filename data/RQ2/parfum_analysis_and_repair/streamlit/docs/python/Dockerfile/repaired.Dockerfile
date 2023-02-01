FROM python:3.9-slim

COPY sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir docstring_parser
RUN pip install --no-cache-dir docutils
RUN pip install --no-cache-dir lxml
RUN pip install --no-cache-dir requests
RUN pip install --no-cache-dir numpydoc
RUN pip install --no-cache-dir protobuf==3.20.1

RUN mkdir -p /docs
COPY build.py /docs
COPY generate.py /docs

WORKDIR /docs
