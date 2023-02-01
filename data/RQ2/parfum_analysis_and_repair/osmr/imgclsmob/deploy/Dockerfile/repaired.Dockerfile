FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
LABEL maintainer="osemery@gmail.com"

RUN apt update
RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y ipython3 git htop mc wget && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade mxnet-cu100
RUN pip3 install --no-cache-dir --upgrade torch torchvision
RUN pip3 install --no-cache-dir --upgrade chainer cupy-cuda100 chainercv
#RUN pip3 install --upgrade keras-mxnet
RUN pip3 install --no-cache-dir --upgrade tensorflow-gpu tensorpack
RUN pip3 install --no-cache-dir --upgrade keras
RUN pip3 install --no-cache-dir --upgrade pandas Pillow tqdm opencv-python
#RUN pip3 install --upgrade gluoncv2 pytorchcv

ADD bootstrap_eval.sh /root/
RUN chmod ugo+x /root/bootstrap_eval.sh
CMD /root/bootstrap_eval.sh