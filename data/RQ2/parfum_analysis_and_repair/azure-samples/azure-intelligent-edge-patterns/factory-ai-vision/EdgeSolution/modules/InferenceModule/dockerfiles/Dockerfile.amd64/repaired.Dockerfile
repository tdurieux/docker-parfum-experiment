# =========================================================
# Base
# =========================================================
FROM amd64/python:3.8-slim-buster

WORKDIR /app

# =========================================================
# Install system packages
# =========================================================
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libffi-dev \
    libgl1-mesa-glx \
    libgtk2.0-dev \
    libssl-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*
# libgl1-mesa-glx: opencv2 libGL.so error workaround

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# TODO: Consider move env to the end of dockerfile
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# =========================================================
# Install Python package
# =========================================================
COPY requirements/base.txt ./requirements/base.txt
COPY requirements/cpu.txt ./requirements/cpu.txt
RUN pip install --no-cache-dir --upgrade pip
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements/cpu.txt --ignore-installed \
    pip install -U pydantic==1.7.2

RUN apt-get install -y --no-install-recommends libglib2.0-0 && rm -rf /var/lib/apt/lists/*;

# ENV CONDA_ENV_NAME python38
# RUN conda create --name python38 python=3.8.5 -y &&\
#     . activate python38
# RUN [ "/bin/bash", "-c", "source activate python38 && pip install --upgrade pip"]
# RUN [ "/bin/bash", "-c", "source activate python38 && pip install -r requirements/cpu.txt --ignore-installed"]

# =========================================================
# Copy Source Code
# =========================================================
COPY coco_classes.txt ./
# COPY default_model default_model/
# COPY default_model_6parts default_model_6parts/
COPY grpc_topology.json ./
COPY http_topology.json ./
# COPY sample_video sample_video/
# COPY scenario_models scenario_models/
# RUN chmod 777 sample_video/video.mp4
# RUN chmod 777 default_model

COPY api/__init__.py ./api/__init__.py
COPY api/models.py ./api/models.py
COPY arguments.py ./
COPY config.py ./
COPY exception_handler.py ./
COPY extension_pb2.py ./
COPY extension_pb2_grpc.py ./
COPY http_inference_engine.py ./
COPY img.png ./
COPY inference_engine.py ./
COPY inferencing_pb2.py ./
COPY invoke.py ./
COPY logging_conf/logging_config.py ./logging_conf/logging_config.py
COPY main.py ./
COPY media_pb2.py ./
COPY model_object.py ./
COPY model_wrapper.py ./
COPY object_detection.py ./
COPY object_detection2.py ./
COPY onnxruntime_predict.py ./
COPY scenarios.py ./
COPY server.py ./
COPY shared_memory.py ./
COPY sort.py ./
COPY stream_manager.py ./
COPY streams.py ./
COPY tracker.py ./
COPY utility.py ./
COPY ovms_utils.py ./
COPY yolo_utils.py ./
COPY cascade/*.py ./cascade/


# remove pip cache
# RUN pip cache purge

# =========================================================
# Run
# =========================================================
EXPOSE 5558
EXPOSE 5000

CMD [ "python", "server.py", "-p", "44000"]
