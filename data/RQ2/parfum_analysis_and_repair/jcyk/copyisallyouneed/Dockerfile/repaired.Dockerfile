FROM mirrors.tencent.com/star_library/g-tlinux2.2-python3.6-cuda10.1-cudnn7.6-pytorch1.4-torchvision0.5-openmpi4.0.3-nccl2.5.6-ofed4.6-horovod:latest

ENV PYTHONIOENCODING=utf-8
ENV LC_CTYPE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV https_proxy="https://10.222.13.250:32810"
ENV http_proxy="http://10.222.13.250:32810"

ADD torch-1.5.1+cu101-cp36-cp36m-linux_x86_64.whl torch-1.5.1+cu101-cp36-cp36m-linux_x86_64.whl

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir sacrebleu && \
    pip3 install --no-cache-dir transformers==2.11.0 && \
    pip3 install --no-cache-dir faiss-gpu==1.6.1 && \
    pip3 install --no-cache-dir jsonlines && \
    pip3 install --no-cache-dir regex && \
    pip3 install --no-cache-dir sklearn && \
    pip3 install --no-cache-dir scipy && \
    pip3 install --no-cache-dir service_streamer && \
    pip3 install --no-cache-dir gunicorn && \
    pip3 install --no-cache-dir torch-1.5.1+cu101-cp36-cp36m-linux_x86_64.whl


