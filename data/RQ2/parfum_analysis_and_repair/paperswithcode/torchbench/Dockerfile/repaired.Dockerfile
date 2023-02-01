FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-runtime

RUN apt-get update && \
        apt-get install --no-install-recommends -y \
        git && \
    rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /workspace

RUN pip --no-cache-dir install -r /workspace/requirements.txt

RUN pip --no-cache-dir install 'git+https://github.com/paperswithcode/torchbench.git'
