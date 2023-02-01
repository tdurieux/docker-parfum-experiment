FROM jjanzic/docker-python3-opencv
WORKDIR /code
RUN apt-get update
RUN apt-get install --no-install-recommends libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .
RUN apt-get update \
    && apt-get install --no-install-recommends -y libsm6 libxext6 libxrender-dev \
    && wget https://awma1-my.sharepoint.com/:u:/g/personal/yuz_l0_tn/EaXvCC3WjtlLvvEfLr3oa8UBLA21tcLh4L8YLbYXl6jgjg?download=1 -O 'bua-caffe-frcn-r101_with_attributes.pth' \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir torch==1.7.1+cpu torchvision==0.8.2+cpu -f https://download.pytorch.org/whl/torch_stable.html \
    && git clone https://github.com/NVIDIA/apex.git \
    && cd apex \
    && git checkout a0d99fdb2cfcc418809dde975f51097c3d6010ca \
    && python setup.py install \
    && cd .. \
    && git clone --recursive https://github.com/MILVLG/bottom-up-attention.pytorch \
    && cd bottom-up-attention.pytorch/detectron2 \
    && pip install --no-cache-dir -e . \
    && cd .. \
    && python setup.py build develop && rm -rf /var/lib/apt/lists/*;
COPY src/ .
CMD [ "python", "./app.py" ]
