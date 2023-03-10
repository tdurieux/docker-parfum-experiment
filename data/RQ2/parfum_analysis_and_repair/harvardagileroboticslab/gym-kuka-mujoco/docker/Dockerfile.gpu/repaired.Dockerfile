FROM araffin/stable-baselines

RUN apt-get -y update && apt-get -y --no-install-recommends install git wget python-dev python3-dev libopenmpi-dev python-pip zlib1g-dev cmake libglib2.0-0 libsm6 libxext6 libfontconfig1 libxrender1 unzip libosmesa6-dev libgl1-mesa-dev libgl1-mesa-glx patchelf libgl1-mesa-glx libglfw3-dev && rm -rf /var/lib/apt/lists/*;
ENV CODE_DIR /root/code
ENV VENV /root/venv


ENV OPENAI_LOG_FORMAT 'stdout,log,csv,tensorboard'
ENV OPENAI_LOGDIR /root
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/root/.mujoco/mjpro150/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/lib/nvidia-390

RUN \
    cd $CODE_DIR && \
    git clone https://github.com/HarvardAgileRoboticsLab/gym-kuka-mujoco.git && \
    cd ~/ && \
    wget https://www.roboti.us/download/mjpro150_linux.zip &&  \
    unzip mjpro150_linux.zip && \
    rm mjpro150_linux.zip && \
    mkdir .mujoco && \
    mv mjpro150 .mujoco/

ARG MJ_KEY
RUN echo "$MJ_KEY" > ~/.mujoco/mjkey.txt

RUN \
    cd $CODE_DIR/gym-kuka-mujoco && \
    pip install --no-cache-dir mujoco_py

ENV PATH=$VENV/bin:$PATH

CMD /bin/bash
