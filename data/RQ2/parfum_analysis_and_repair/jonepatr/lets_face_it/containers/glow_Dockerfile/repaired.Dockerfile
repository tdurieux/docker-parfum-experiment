FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-runtime
RUN conda init
COPY . .
RUN conda env update -f /workspace/code/glow_pytorch/environment.yml
RUN pip install --no-cache-dir -e /workspace/code
WORKDIR /workspace