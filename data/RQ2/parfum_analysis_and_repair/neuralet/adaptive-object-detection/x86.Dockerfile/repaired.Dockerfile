FROM tensorflow/tensorflow:2.2.2-py3

VOLUME  /repo
WORKDIR /repo

RUN apt update && apt install --no-install-recommends -y libgl1-mesa-glx zip vim && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip setuptools==41.0.0 && pip install --no-cache-dir opencv-python wget pillow

