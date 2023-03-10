FROM arm32v7/ubuntu:19.10

ARG CREDENTIALS
ENV CREDENTIALS $CREDENTIALS
RUN echo $CREDENTIALS

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y mpg123 python3-pyaudio vim python3 python3-pip curl mpg321 \
    alsa-utils libasound2-plugins wget build-essential python-opencv python3-opencv cython3 cython python3-scipy \
    python3-matplotlib python3-cffi python3-greenlet python3-pycparser python3-gevent python3-grpcio python3-h5py \
    libxml2-dev libxslt-dev python3-lxml libopenblas-dev pciutils alsa alsa-base libhdf5-dev libhd-dev apt-transport-https \
    ca-certificates \
    && rm -fr /var/lib/apt/lists/*

COPY do_make_tf_armv7_download.sh get_arm.sh
RUN ./get_arm.sh

#RUN mv tensorflow-1.14.0-cp35-none-linux_armv7l.whl tensorflow-1.14.0-cp37-none-linux_armv7l.whl

RUN pip3 install --no-cache-dir opencv_python-4.1.1.26-cp37-cp37m-linux_armv7l.whl
RUN pip3 install --no-cache-dir torch-1.4.0a0+7f73f1d-cp37-cp37m-linux_armv7l.whl
RUN pip3 install --no-cache-dir tensorflow-1.15.0-cp37-cp37m-linux_armv7l.whl
#RUN pip3 install tflite_runtime-1.15.2-cp37-cp37m-linux_armv7l.whl

### for tensorflow 1.14.0
#RUN sed -i '31s/.*/    pass ##no line here##/' /usr/local/lib/python3.7/dist-packages/tensorflow/contrib/__init__.py

COPY requirements.armv7.txt requirements.txt

RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir --upgrade pip

RUN apt-get update && apt-get install --no-install-recommends -y git qemu-user-static qemu binfmt-support iptables iputils-ping lxc \
    ca-certificates apt-transport-https libhdf5-dev libhdf5-103 libffi-dev libaec0 libsz2 && rm -rf /var/lib/apt/lists/*;

#VOLUME /var/lib/docker
#ADD docker/scripts/wrapdocker.sh /usr/local/bin/wrapdocker
#RUN chmod +x /usr/local/bin/wrapdocker

#RUN  curl -fsSLk get.docker.com -o get-docker.sh
#COPY docker/scripts/get-docker.sh /get-docker.sh

#RUN sh get-docker.sh
#RUN apt-get -y install docker-ce docker-ce-cli docker-compose
#RUN service docker start


RUN pip3 install --no-cache-dir tensor2tensor==1.15.5 tensorflow-serving-api==1.15.0#tensorflow-datasets==1.0.2
RUN apt-get -y remove python3-mpi4py

RUN pip3 install --no-cache-dir h5py-2.9.0-cp37-cp37m-linux_armv7l.whl

RUN echo "@audio - rtprio 99" >> /etc/security/limits.conf
RUN echo "snd-hda-intel" >> /etc/modules
RUN echo "options snd-hda-intel model=auto" >> /etc/modprobe.d/alsa-base.conf
RUN echo "options snd-hda-intel dmic_detect=0" >> /etc/modprobe.d/alsa-base.conf
RUN echo "blacklist snd_soc_skl" >> /etc/modprobe.d/blacklist.conf

RUN mkdir /app
#VOLUME /app

WORKDIR app

#CMD ['wrapdocker']
#ENTRYPOINT wrapdocker