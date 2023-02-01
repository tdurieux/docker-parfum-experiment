FROM openhorizon/aarch64-tx2-nvidia-caffe

#AUTHOR bmwshop@gmail.com
MAINTAINER nuculur@gmail.com

WORKDIR /
RUN apt-get update
RUN apt-get install -y python-pip
RUN pip install --upgrade pip
RUN apt-get install --no-install-recommends -y git graphviz python-dev python-flask python-flaskext.wtf python-gevent python-h5py python-numpy python-pil python-protobuf python-scipy python-tk

ENV CAFFE_ROOT /caffe
ENV DIGITS_ROOT /digits
RUN git clone https://github.com/NVIDIA/DIGITS.git 
#RUN pip install -r $DIGITS_ROOT/requirements.txt
RUN pip install -r /DIGITS/requirements.txt
# RUN pip install -e $DIGITS_ROOT
RUN pip install -e /DIGITS

CMD /DIGITS/digits-devserver -p 5001
