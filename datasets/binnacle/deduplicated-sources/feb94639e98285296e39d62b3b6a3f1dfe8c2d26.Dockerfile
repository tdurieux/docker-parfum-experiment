FROM tensorflow/tensorflow:1.13.1-gpu-py3
LABEL maintainer="christopher.lennan@idealo.de"

# add extra PPA for python 3.6
# https://askubuntu.com/questions/865554/how-do-i-install-python-3-6-using-apt-get
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update && apt-get install -y python3.6

RUN pip --no-cache-dir install --upgrade \
    pip \
    setuptools \
    virtualenv

# create python3.6 virtualenv and install tensorflow
RUN virtualenv -p python3.6 ~/.venvs/image-atm

RUN /bin/bash -c "source ~/.venvs/image-atm/bin/activate && pip install \
  tensorflow-gpu==1.13.1 \
  Keras>=2.2.4 \
  keras-vis>=0.4.1 \
  awscli \
  Click \
  h5py \
  matplotlib \
  Pillow \
  python-dateutil \
  scikit-learn \
  scipy==1.1.* \
  tqdm \
  yarl"

WORKDIR /root/repo

RUN mkdir /root/repo/imageatm
COPY imageatm /root/repo/imageatm
COPY entrypoints/entrypoint.train.gpu.sh .

RUN echo source ~/.venvs/image-atm/bin/activate >> /etc/bash.bashrc

ENTRYPOINT ["/root/repo/entrypoint.train.gpu.sh"]
