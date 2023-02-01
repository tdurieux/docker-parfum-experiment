FROM python:3.8-slim

# install deps
RUN apt-get update && apt-get -y --no-install-recommends install \
    bash ffmpeg && rm -rf /var/lib/apt/lists/*;

# setup RIFE
WORKDIR /rife
COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt

ADD docker/inference_img /usr/local/bin/inference_img
RUN chmod +x /usr/local/bin/inference_img
ADD docker/inference_video /usr/local/bin/inference_video
RUN chmod +x /usr/local/bin/inference_video

# add pre-trained models
COPY train_log /rife/train_log

WORKDIR /host
ENTRYPOINT ["/bin/bash"]

ENV NVIDIA_DRIVER_CAPABILITIES all