FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04
RUN apt-get update && apt-get install -y software-properties-common  && echo 1
RUN add-apt-repository -y ppa:deadsnakes/ppa && \
      apt-get update && \
      apt-get upgrade -y && \
      apt-get install -y python3.6 python3.6-dev build-essential cmake libgtk2.0-dev && \
      curl https://bootstrap.pypa.io/get-pip.py | python3.6

# Install snet daemon
ARG SNETD_VERSION=v0.1.8
RUN mkdir -p /tmp/snetd && cd /tmp/snetd && \
      curl -OL https://github.com/singnet/snet-daemon/releases/download/$SNETD_VERSION/snet-daemon-$SNETD_VERSION-linux-amd64.tar.gz && \
      tar -xvf snet-daemon-$SNETD_VERSION-linux-amd64.tar.gz && \
      mv snet-daemon-$SNETD_VERSION-linux-amd64/snetd /usr/bin/snetd && \
      cd / && rm -r /tmp/snetd

RUN apt-get install -y libusb-1.0-0.dev libudev-dev

ADD requirements.txt /requirements.txt
RUN pip3.6 install -r requirements.txt

ADD . /face-services
WORKDIR /face-services
RUN ./buildproto.sh

CMD ["python3.6", "run_services.py"]