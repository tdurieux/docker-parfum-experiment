FROM pytorch/pytorch:1.2-cuda10.0-cudnn7-devel

RUN pip uninstall -y pillow \
    && pip install --no-cache-dir \
    pillow-simd \
    scipy \
    mlconfig \
    && rm -rf ~/.cache/pip

WORKDIR /workspace
