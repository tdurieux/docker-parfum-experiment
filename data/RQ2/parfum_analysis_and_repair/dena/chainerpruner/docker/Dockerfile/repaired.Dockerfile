FROM chainer/chainer:v7.0.0a1-python3

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV LANGUAGE en_US

RUN pip3 install --no-cache-dir -U pip setuptools
RUN pip3 install --no-cache-dir \
    networkx \
    chainercv \
    scipy \
    chainer_computational_cost

RUN pip3 install --no-cache-dir torch torchvision

RUN pip3 install --no-cache-dir git+https://github.com/DeNA/ChainerPruner