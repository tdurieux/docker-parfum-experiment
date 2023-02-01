ARG BASEIMAGE=nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04
FROM ${BASEIMAGE}

ADD ./docker/scripts /install/scripts
RUN bash /install/scripts/find-fastest-apt.sh

ARG DISC_WHEEL=blade_disc*.whl
ARG TF_BLADE_WHEEL=tensorflow_blade*.whl

ADD ./build/${DISC_WHEEL}  /install/python/
ADD ./build/${TF_BLADE_WHEEL}  /install/python/

RUN apt-get install --no-install-recommends -y python3 python3-pip \
    && pip3 install --no-cache-dir --upgrade pip \
    && ln -s /usr/bin/python3.6 /usr/bin/python \
    && pip install --no-cache-dir /install/python/${DISC_WHEEL} \
    && pip install --no-cache-dir /install/python/${TF_BLADE_WHEEL} && rm -rf /var/lib/apt/lists/*;
