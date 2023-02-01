FROM nvcr.io/nvidia/tensorflow:20.03-tf2-py3

VOLUME  /repo
WORKDIR /repo

RUN apt-get update && apt-get install --no-install-recommends -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip setuptools==41.0.0 && pip install --no-cache-dir opencv-python wget pillow

