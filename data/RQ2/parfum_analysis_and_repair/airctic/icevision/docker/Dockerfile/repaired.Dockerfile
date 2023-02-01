FROM python:3.8

RUN pip install --no-cache-dir torch==1.8.0+cu101 torchvision==0.9.0+cu101 -f https://download.pytorch.org/whl/torch_stable.html -U
RUN pip install --no-cache-dir git+https://github.com/airctic/icevision.git#egg=icevision[all] -U
RUN pip install --no-cache-dir git+https://github.com/airctic/icedata.git -U
RUN pip install --no-cache-dir yolov5-icevision -U
RUN pip install --no-cache-dir mmcv-full==1.3.7 -f https://download.openmmlab.com/mmcv/dist/cu101/torch1.8.0/index.html -U
RUN pip install --no-cache-dir mmdet==2.13.0 -U
RUN pip install --no-cache-dir mmsegmentation==0.17.0 -U
RUN pip install --no-cache-dir ipywidgets