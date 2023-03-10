FROM mrdanish/tensorflow-rpi:1.15.0-aarch64

RUN [ "cross-build-start" ]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y --allow-downgrades \
            git \
            python3-matplotlib python3-numpy python3-sklearn python3-opencv python3-h5py python3-pandas python3-scipy python3-uvloop \
            libmosquitto-dev \
            fonts-freefont-ttf \
            libatlas-base-dev \
            vim less wget && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip wheel setuptools
RUN pip3 install --no-cache-dir quart gmqtt cameratransform opencv-python pillow
#RUN pip3 install https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp37-cp37m-linux_x86_64.whl
RUN pip3 install --no-cache-dir https://github.com/google-coral/pycoral/releases/download/release-frogfish/tflite_runtime-2.5.0-cp37-cp37m-linux_aarch64.whl
RUN pip3 install --no-cache-dir --upgrade uvloop

USER root
RUN mkdir -p /deepdish/detectors/yolo
RUN wget -O /deepdish/detectors/yolo/yolo.h5 https://github.com/OlafenwaMoses/ImageAI/releases/download/1.0/yolo.h5

ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

RUN mkdir -p /work
RUN chown -R user:user /work # /yolo

# Allow password-less 'root' login with 'su'
RUN passwd -d root
RUN sed -i 's/nullok_secure/nullok/' /etc/pam.d/common-auth

RUN echo $'#!/bin/bash\nPYTHONPATH=/deepdish DEEPDISHHOME=/deepdish python3 /deepdish/deepdish.py $@' > /usr/bin/deepdish.sh

RUN chmod +x /usr/bin/deepdish.sh

COPY *.py /deepdish/
COPY detectors/mobilenet/* /deepdish/detectors/mobilenet/
COPY detectors/yolo/* /deepdish/detectors/yolo/
COPY encoders/* /deepdish/encoders/
COPY yolo3/*.py /deepdish/yolo3/
COPY tools/*.py /deepdish/tools/
COPY deep_sort/*.py /deepdish/deep_sort/

RUN [ "cross-build-end" ]

USER user

WORKDIR /work

CMD /bin/bash

