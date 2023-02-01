FROM tschaffter/caffe-gpu

RUN yum install -y opencv && rm -rf /var/cache/yum

RUN pip install --no-cache-dir pydicom \
    matplotlib \
    synapseclient \
    lmdb \
    sklearn

WORKDIR /
COPY deploy_alexnet.prototxt .
COPY solver_alexnet.prototxt .
COPY train_val_alexnet.prototxt .
COPY train.sh .
