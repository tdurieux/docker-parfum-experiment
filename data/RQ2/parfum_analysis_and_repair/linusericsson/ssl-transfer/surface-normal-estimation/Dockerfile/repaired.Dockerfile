FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime
RUN apt-get update && apt-get install --no-install-recommends -y git libgl1-mesa-glx libglib2.0-0 imagemagick && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir opencv-python
