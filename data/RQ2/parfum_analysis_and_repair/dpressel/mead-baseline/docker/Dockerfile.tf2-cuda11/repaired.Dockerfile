# This is built on CUDA 11
FROM tensorflow/tensorflow:2.4.1-gpu

COPY . /usr/mead/mead-baseline

WORKDIR /usr/mead

RUN cd mead-baseline/layers && pip install --no-cache-dir .
RUN cd mead-baseline && pip install --no-cache-dir .[tf2,test,yaml]

# Set env variables
# Set baseline logging vars
ENV TIMING_LOG_LEVEL=DEBUG
# Set terminal encodings
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
# Set ENV to tensorflow can find cuda
ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Install tensorflow
RUN python -m pip install tensorflow_addons && \
    python -m pip install tensorflow-hub && \
    python -m pip install Cython && \
    python -m pip install fastBPE && \
    python -m pip install mead-xpctl-client

ENTRYPOINT ["mead-train", "--config", "config/sst2.json"]

