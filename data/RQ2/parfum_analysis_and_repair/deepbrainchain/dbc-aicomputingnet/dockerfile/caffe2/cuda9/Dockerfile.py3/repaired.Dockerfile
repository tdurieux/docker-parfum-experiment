FROM nvcr.io/nvidia/caffe2:18.01-py3

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir nltk
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir gensim
