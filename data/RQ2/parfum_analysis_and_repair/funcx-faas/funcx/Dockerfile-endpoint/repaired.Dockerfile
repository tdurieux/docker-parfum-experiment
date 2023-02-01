ARG PYTHON_VERSION="3.8"
FROM python:${PYTHON_VERSION}
RUN mkdir /opt/funcx
RUN pip install --no-cache-dir kubernetes
RUN pip install --no-cache-dir --no-binary :all: --force-reinstall pyzmq

COPY funcx_sdk /opt/funcx/funcx_sdk/
WORKDIR /opt/funcx/funcx_sdk
RUN pip install --no-cache-dir .

COPY funcx_endpoint /opt/funcx/funcx_endpoint
WORKDIR /opt/funcx/funcx_endpoint
RUN pip install --no-cache-dir .

RUN useradd -m funcx
RUN mkdir -p /home/funcx/.kube
USER funcx
WORKDIR /home/funcx
COPY helm/boot.sh .
ENV HOME /home/funcx
