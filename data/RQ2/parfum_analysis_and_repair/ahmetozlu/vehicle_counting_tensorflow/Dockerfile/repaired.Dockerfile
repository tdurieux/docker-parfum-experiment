FROM tensorflow/tensorflow:1.4.0-gpu-py3

RUN apt update -y && apt install --no-install-recommends -y \
python3-dev \
libsm6 \
libxext6 \
libxrender-dev \
python3-tk && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir \
numpy \
opencv-python \
matplotlib
