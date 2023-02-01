# Start FROM Nvidia PyTorch image https://ngc.nvidia.com/catalog/containers/nvidia:pytorch
FROM nvcr.io/nvidia/pytorch:21.10-py3

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get install --no-install-recommends -y ffmpeg && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.config/Ultralytics/
# prevent YOLOv5 from downloading unnecessary assets
RUN ln /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf /root/.config/Ultralytics/Arial.ttf

RUN pip install --no-cache-dir imageio imageio-ffmpeg tqdm seaborn && \
  rm -rf /root/.cache/pip

ARG GIT_SHA=c72270c076e1f087d3eb0b1ef3fb7ab55fe794ba
RUN mkdir -p /root/.cache/torch/hub/ && \
  curl -f -L https://github.com/ultralytics/yolov5/archive/${GIT_SHA}.zip > /tmp/yolov5.zip && \
  unzip -D -q /tmp/yolov5.zip -d /root/.cache/torch/hub/ && \
  mv /root/.cache/torch/hub/yolov5-${GIT_SHA} /root/.cache/torch/hub/ultralytics_yolov5_master

# work around https://github.com/pytorch/pytorch/issues/67598
RUN sed -i "s/if torch.cuda.amp.common.amp_definitely_not_available() and self.device == 'cuda':/if enabled and torch.cuda.amp.common.amp_definitely_not_available() and self.device == 'cuda':/" /opt/conda/lib/python3.8/site-packages/torch/autocast_mode.py

COPY detector.py /workspace/

ENTRYPOINT ["/workspace/detector.py"]
CMD ["/videos/detect_latest.pt", "/videos/source/"]


# example usage from project main dir:
# DOCKER_BUILDKIT=1 docker build -f "tools/detection/Dockerfile.pytorch" "tools/detection/" --network host -t "veloroute.hamburg/docker:detector"
# docker run --rm --gpus all --tty --name veloroute2detect --mount "type=bind,source=$(pwd)/videos/,target=/videos/" "veloroute.hamburg/docker:detector"
