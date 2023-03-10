FROM dokai:pytorch

# Install TensorStream
RUN git clone --depth=1 --branch=dev --progress https://github.com/osai-ai/tensor-stream.git && \
    cd tensor-stream && \
    python setup.py install && \
    cd .. && rm -rf tensor-stream