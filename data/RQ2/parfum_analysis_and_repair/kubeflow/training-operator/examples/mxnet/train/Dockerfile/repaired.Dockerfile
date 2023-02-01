FROM mxnet/python:gpu

RUN apt-get update && \
    apt-get install --no-install-recommends -y git && \
    git clone https://github.com/apache/incubator-mxnet.git -b v1.6.x && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["python", "/incubator-mxnet/example/image-classification/train_mnist.py"]
