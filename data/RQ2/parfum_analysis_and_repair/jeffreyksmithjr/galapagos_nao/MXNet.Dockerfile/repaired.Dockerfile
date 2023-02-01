FROM elixir:latest

RUN apt-get update \
  && apt-get install --no-install-recommends -y wget python gcc \
  && wget https://bootstrap.pypa.io/get-pip.py \
  && python get-pip.py \
  && pip install --no-cache-dir mxnet==1.2.0b20180512 \
  && apt-get install --no-install-recommends -y graphviz \
  && pip install --no-cache-dir graphviz \
  && pip install --no-cache-dir Pillow \
  && pip install --no-cache-dir onnx && rm -rf /var/lib/apt/lists/*;
