FROM meadml/cuda11.1-cudnn8-devel-ubuntu18.04-python3.8

COPY . /usr/mead/mead-baseline
WORKDIR /usr/mead

RUN cd mead-baseline/layers && pip install --no-cache-dir --no-use-pep517 .
RUN cd mead-baseline && pip install --no-cache-dir --no-use-pep517 .[test,yaml]

# Set env variables
# Set baseline logging vars
ENV TIMING_LOG_LEVEL=DEBUG
# Set terminal encodings
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

COPY . /usr/mead

# Install pytorch


RUN python3.8 -m pip --no-cache-dir install torch==1.8.2+cu111 -f https://download.pytorch.org/whl/lts/1.8/torch_lts.html && \
    python3.8 -m pip install Cython && \
    python3.8 -m pip install fastBPE && \
    python3.8 -m pip install regex && \
    python3.8 -m pip install tfrecord && \
    python3.8 -m pip install tensorboard && \
    python3.8 -m pip install mead-xpctl-client && \
    python3.8 -m pip install transformers && \
    python3.8 -m pip install pandas && \
    python3.8 -m pip install sentencepiece


ENTRYPOINT ["mead-train", "--config", "config/conll.json"]

