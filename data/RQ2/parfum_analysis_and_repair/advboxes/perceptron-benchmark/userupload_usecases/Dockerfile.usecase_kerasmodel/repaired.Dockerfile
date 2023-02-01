FROM nvcr.io/nvidia/tensorflow:19.08-py3

RUN apt-get update && apt-get install --no-install-recommends -y sudo libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;
RUN sudo pip3 install --no-cache-dir https://download.pytorch.org/whl/cu102/torch-1.5.1-cp36-cp36m-linux_x86_64.whl
RUN sudo pip3 install --no-cache-dir torchvision
RUN sudo pip3 install --no-cache-dir keras==2.2.5
RUN sudo pip3 install --no-cache-dir tqdm
RUN sudo pip3 install --no-cache-dir opencv-python

RUN sudo pip3 install --no-cache-dir tf-slim

RUN mkdir /perceptron
WORKDIR /perceptron
ADD . /perceptron
RUN sudo pip3 install --no-cache-dir -e .
RUN git clone https://github.com/tensorflow/models.git
ENV PYTHONPATH=/perceptron/models/research/slim
