FROM    mxnet/python:gpu_0.11.0

RUN apt-get update && apt-get install --no-install-recommends -y \
        nano \
        wget \
        graphviz \
        python-tk && rm -rf /var/lib/apt/lists/*;


RUN pip install --no-cache-dir ipython jupyter matplotlib scipy graphviz tensorboard future

WORKDIR /mxnet/example/ssd
