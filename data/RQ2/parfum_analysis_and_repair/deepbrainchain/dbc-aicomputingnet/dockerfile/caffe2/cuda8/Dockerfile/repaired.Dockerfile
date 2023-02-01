FROM caffe2ai/caffe2:c2v0.8.1.cuda8.cudnn7.ubuntu16.04

RUN apt-get update && apt-get install --no-install-recommends --yes \
    curl && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir nltk
RUN pip install --no-cache-dir numpy
