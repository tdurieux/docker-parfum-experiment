#This container will install TensorFlow Object Detection API and its dependencies in the /model/research/object_detection directory

FROM tensorflow/tensorflow:1.15.0-gpu-py3

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install --no-install-recommends -y git protobuf-compiler python3-tk vim && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir Cython && \
    pip install --no-cache-dir contextlib2 && \
    pip install --no-cache-dir pillow && \
    pip install --no-cache-dir lxml && \
    pip install --no-cache-dir jupyter && \
    pip install --no-cache-dir matplotlib

RUN git clone --depth 1 https://github.com/tensorflow/models.git

RUN git clone --depth 1 https://github.com/cocodataset/cocoapi.git && \
    cd cocoapi/PythonAPI && \
    make && \
    cp -r pycocotools/ /models/research/

RUN cd /models/research && \
    protoc object_detection/protos/*.proto --python_out=.

RUN echo 'export PYTHONPATH=$PYTHONPATH:/models/research:/models/research/slim' >> ~/.bashrc && \
    echo 'export export TF_FORCE_GPU_ALLOW_GROWTH=true' >> ~/.bashrc && \
    source ~/.bashrc

WORKDIR /models/research
