FROM nvcr.io/nvidia/tritonserver:22.05-py3

# see .dockerignore to check what is transfered
COPY . ./

RUN pip3 install --no-cache-dir -U pip && \
    pip3 install --no-cache-dir nvidia-pyindex && \
    pip3 install ".[GPU]" -f https://download.pytorch.org/whl/cu113/torch_stable.html --extra-index-url https://pypi.ngc.nvidia.com --no-cache-dir && \
    pip3 install --no-cache-dir sentence-transformers notebook pytorch-quantization ipywidgets
