FROM nvcr.io/nvidia/pytorch:21.02-py3

RUN apt update
ENV TZ=Asia/Seoul
RUN DEBIAN_FRONTEND="noninteractive" apt --no-install-recommends install -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends python3-opencv -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN apt install -y --no-install-recommends gcc && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir cython >=0.27.3 matplotlib tabulate termcolor tensorboard
#RUN pip3 install tabulate scipy pycocotools progressbar

WORKDIR /app
#RUN git clone https://github.com/Ze-Yang/Context-Transformer.git
#WORKDIR Context-Transformer
#COPY make.sh make.sh
#COPY data/VOCdevkit data/VOCdevkit
#COPY weights weights
#RUN sh make.sh
#WORKDIR data
#RUN unzip Main2007.zip -d VOCdevkit/VOC2007/ImageSets
#WORKDIR /app/Context-Transformer

RUN git clone https://github.com/Tianxiaomo/pytorch-YOLOv4.git
WORKDIR pytorch-YOLOv4
#RUN pip install -r requirements.txt
RUN mkdir weights
COPY yolov4.pth weights/yolov4.pth

WORKDIR /app
RUN git clone https://github.com/KaiyangZhou/deep-person-reid.git
WORKDIR deep-person-reid
RUN pip install --no-cache-dir gdown
RUN python setup.py develop