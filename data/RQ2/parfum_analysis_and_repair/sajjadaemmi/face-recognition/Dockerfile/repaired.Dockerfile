FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-devel

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC
RUN apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /workspace/face-recognition
COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir mmcv-full -f https://download.openmmlab.com/mmcv/dist/cu113/torch1.11.0/index.html
