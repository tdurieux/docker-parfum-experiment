ARG FROM_IMAGE_NAME=nvcr.io/nvidia/tensorflow:20.12-tf1-py3
ARG TRITON_CLIENT_IMAGE_NAME=nvcr.io/nvidia/tritonserver:20.12-py3-sdk
FROM ${TRITON_CLIENT_IMAGE_NAME} as triton-client
FROM ${FROM_IMAGE_NAME}

# Install perf_client required library
RUN apt-get update && \
    apt-get install --no-install-recommends -y libb64-dev libb64-0d && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Triton Client PythonAPI and copy Perf Client
COPY --from=triton-client /workspace/install/ /workspace/install/
ENV LD_LIBRARY_PATH /workspace/install/lib:${LD_LIBRARY_PATH}
RUN find /workspace/install/python/ -iname triton*manylinux*.whl -exec pip install --no-cache-dir {}[all] \;

# Setup environmnent variables to access Triton Client lib and bin
ENV PATH /workspace/install/bin:${PATH}

ENV PYTHONPATH /workspace/rn50v15_tf
WORKDIR /workspace/rn50v15_tf

RUN pip uninstall -y typing

ADD requirements.txt .
ADD triton/requirements.txt triton/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir --extra-index-url https://pypi.ngc.nvidia.com -r triton/requirements.txt

ADD . .
