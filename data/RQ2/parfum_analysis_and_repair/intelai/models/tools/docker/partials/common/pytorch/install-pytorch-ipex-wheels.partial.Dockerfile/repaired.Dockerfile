# Install PyTorch and IPEX wheels
ARG PYTORCH_WHEEL
ARG IPEX_WHEEL

COPY ./whls/* /tmp/pip3/
RUN source activate pytorch && \
    pip install --no-cache-dir /tmp/pip3/${IPEX_WHEEL} && \
    pip install --no-cache-dir /tmp/pip3/${PYTORCH_WHEEL}

