From nvcr.io/nvidia/pytorch:19.04-py3

RUN apt-get -y update

RUN apt-get install -y python3-pip software-properties-common wget ffmpeg

RUN add-apt-repository ppa:git-core/ppa

RUN apt-get -y update

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

RUN apt-get install -y git-lfs --allow-unauthenticated

RUN git lfs install

ENV GIT_WORK_TREE=/data

RUN mkdir -p /root/.torch/models

RUN mkdir -p /data/models

RUN wget -O /root/.torch/models/vgg16_bn-6c64b313.pth https://download.pytorch.org/models/vgg16_bn-6c64b313.pth

RUN wget -O /root/.torch/models/resnet34-333f7ec4.pth https://download.pytorch.org/models/resnet34-333f7ec4.pth

RUN wget -O /root/.torch/models/resnet101-5d3b4d8f.pth https://download.pytorch.org/models/resnet101-5d3b4d8f.pth

RUN wget -O /data/models/ColorizeArtistic_gen.pth https://www.dropbox.com/s/zkehq1uwahhbc2o/ColorizeArtistic_gen.pth?dl=0 

RUN wget -O /data/models/ColorizeVideo_gen.pth https://www.dropbox.com/s/336vn9y4qwyg9yz/ColorizeVideo_gen.pth?dl=0

ADD . /data/

WORKDIR /data

RUN pip install -r requirements.txt

RUN pip install  Flask

RUN cd /data/test_images && git lfs pull

EXPOSE 5000

ENTRYPOINT ["python3", "app.py"]

