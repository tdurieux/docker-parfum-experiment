FROM tensorflow/tensorflow:1.15.2-gpu-py3

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install libsm6 libxrender-dev libxext6 libcap-dev ffmpeg git && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /workspace/mot

ADD requirements.txt /workspace/mot

RUN pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir jupyter==1.0.0 && \
    rm requirements.txt

ADD . /workspace/mot

ENV PYTHONPATH $PYTHONPATH:/workspace/mot/src
