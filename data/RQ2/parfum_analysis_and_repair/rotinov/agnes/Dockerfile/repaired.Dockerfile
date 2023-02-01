FROM pytorch/pytorch

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install ffmpeg \
    && apt-get -y --no-install-recommends install mpich \
    && apt-get -y --no-install-recommends install libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;
# RUN apt-get -y update && apt-get -y install git wget python-dev python3-dev libopenmpi-dev python-pip zlib1g-dev cmake python-opencv

ENV CODE_DIR /root/code

COPY . $CODE_DIR/AGNES
WORKDIR $CODE_DIR/AGNES

RUN rm -rf __pycache__ && \
    find . -name "*.pyc" -delete && \
    pip install --no-cache-dir opencv-python && \
    pip install --no-cache-dir mpi4py Tensorboard && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir .


CMD /bin/bash
