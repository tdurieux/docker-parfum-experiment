FROM nvcr.io/nvidia/tensorrt:20.12-py3
WORKDIR /pose
RUN apt update
# RUN apt install -y ffmpeg libsm6 libxext6
RUN apt install --no-install-recommends -y libgl1 && rm -rf /var/lib/apt/lists/*;
# RUN apt install -y libgl1-mesa-dri
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade pip; \
    pip install --no-cache-dir -r requirements.txt
# install sudo
RUN apt-get update
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;

# install torch2trt
WORKDIR /
RUN git clone https://github.com/NVIDIA-AI-IOT/torch2trt
WORKDIR /torch2trt/
RUN sudo python3 setup.py install --plugins

WORKDIR /
RUN git clone https://github.com/NVIDIA-AI-IOT/trt_pose
WORKDIR /trt_pose/
RUN sudo python3 setup.py install

# download the pose estimation models
RUN gdown --id 13FkJkx7evQ1WwP54UmdiDXWyFMY1OxDU
RUN gdown --id 1XYDdCUdiF2xxx4rznmLb62SdOUZuoNbd

# for multiprocessing
RUN pip3 install --no-cache-dir multiprocess

WORKDIR /pose/src/