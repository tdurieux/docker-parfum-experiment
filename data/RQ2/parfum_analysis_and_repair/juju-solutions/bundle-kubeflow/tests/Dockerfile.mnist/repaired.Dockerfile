# docker build tests/ -f tests/Dockerfile.mnist -t upload.rocks.canonical.com:5000/kubeflow/examples/mnist-test:latest
# docker push upload.rocks.canonical.com:5000/kubeflow/examples/mnist-test:latest

FROM tensorflow/tensorflow:1.14.0-py3

RUN pip install --no-cache-dir requests kubernetes
