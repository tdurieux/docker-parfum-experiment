FROM  pytorch/pytorch:1.3-cuda10.1-cudnn7-devel

RUN apt update && apt install --no-install-recommends -y ffmpeg libsm6 libxrender-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir Cython
RUN pip install --no-cache-dir opencv-python cython_bbox motmetrics numba matplotlib sklearn
