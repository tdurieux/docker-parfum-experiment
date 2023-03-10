FROM mxnet/python:1.4.0_cpu_mkl_py3

RUN apt-get update \
    && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN git clone --recursive https://github.com/apache/incubator-mxnet

ENTRYPOINT ["python3", "/mxnet/incubator-mxnet/example/image-classification/train_mnist.py"]
