FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-devel

ENV DEBIAN_FRONTEND=noniteractive
RUN apt update -y && \
    apt install --no-install-recommends -y \
    libopencv-dev && rm -rf /var/lib/apt/lists/*;

ARG UID
RUN useradd -l -m -u ${UID} dockeruser
USER ${UID}
ENV PATH=$PATH:/home/dockeruser/.local/bin

COPY docker/torch/requirements.txt requirements.txt
RUN pip --default-timeout=100 --no-cache-dir install --user -r requirements.txt
