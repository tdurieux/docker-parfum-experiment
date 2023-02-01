FROM nvcr.io/nvidia/pytorch:21.02-py3

RUN pip install --no-cache-dir pytorch-lightning==1.2.2
RUN pip install --no-cache-dir torchmetrics

RUN git clone https://github.com/PyTorchLightning/pytorch-lightning.git
COPY test.sh /
