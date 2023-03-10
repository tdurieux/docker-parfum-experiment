ARG BASE_IMAGE
FROM ${BASE_IMAGE} as ci
ARG EXTRA_PYPI_INDEX=https://pypi.org/simple

WORKDIR /

COPY elasticdl/docker/bashrc /etc/bash.bashrc
RUN chmod a+rx /etc/bash.bashrc

# Copy model zoo
COPY model_zoo /model_zoo
RUN python -m pip install --quiet -r /model_zoo/requirements.txt \
        --extra-index-url=${EXTRA_PYPI_INDEX}

# Install ElasticDL packages
COPY build/*.whl /
RUN pip install --no-cache-dir /*.whl --extra-index-url=${EXTRA_PYPI_INDEX} && rm /*.whl

# Add elasticdl_ps to system path
RUN /bin/bash -c \
        'PYTHON_PKG_PATH=$(pip3 show elasticdl | grep "Location:" | cut -d " " -f2); \
        echo "PATH=${PYTHON_PKG_PATH}/elasticdl/go/bin:$PATH" >> \
            /root/.bashrc_elasticdl; \
        echo ". /root/.bashrc_elasticdl" >> /root/.bashrc'

# Generate mnist checkpoint for evaluation and prediction
COPY scripts/travis/gen_mnist_checkpoint.py /gen_mnist_checkpoint.py
RUN python /gen_mnist_checkpoint.py --checkpoint_dir=/model_zoo/test_data/mnist_ckpt
