FROM tensorflow/tensorflow:1.13.2

RUN apt-get update \
    && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone --depth 1 https://github.com/aymericdamien/TensorFlow-Examples.git
RUN python -m pip install -U pip setuptools
RUN python -m pip install matplotlib
