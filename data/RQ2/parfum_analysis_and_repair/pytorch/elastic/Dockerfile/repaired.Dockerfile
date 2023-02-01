FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-runtime

# install torchelastic
WORKDIR /opt/torchelastic
COPY . .
RUN pip install --no-cache-dir -v .

WORKDIR /workspace
RUN chmod -R a+w .
