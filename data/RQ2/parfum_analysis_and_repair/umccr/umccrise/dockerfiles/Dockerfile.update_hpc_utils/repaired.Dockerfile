FROM umccr/umccrise:0.10.6

RUN git clone https://github.com/umccr/hpc_utils && \
    cd hpc_utils && \
    rm -rf .git && \
    pip install --no-cache-dir -e .