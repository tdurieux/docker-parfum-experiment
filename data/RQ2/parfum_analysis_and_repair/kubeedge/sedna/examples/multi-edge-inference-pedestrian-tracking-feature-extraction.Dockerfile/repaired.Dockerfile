FROM python:3.8
#FROM python:3.7-slim-bullseye

WORKDIR /home

## Install git
RUN apt update

# Required by OpenCV
RUN apt install --no-install-recommends libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;

# RUN apt install -y git
RUN apt install --no-install-recommends -y gfortran libopenblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*;

## Install base dependencies
RUN pip install --no-cache-dir torch torchvision tqdm opencv-python pillow pytorch-ignite

## Add Kafka Python library
RUN pip install --no-cache-dir kafka-python

# ONNX
RUN pip install --no-cache-dir onnx protobuf==3.16.0

## SEDNA SECTION ##

COPY ./lib/requirements.txt /home
RUN pip install --no-cache-dir -r /home/requirements.txt

ENV PYTHONPATH "${PYTHONPATH}:/home/lib"

WORKDIR /home/work
COPY ./lib /home/lib

# Add M3L imports
COPY examples/multiedgeinference/pedestrian_tracking/feature_extraction /home/work

ENV PYTHONPATH "${PYTHONPATH}:/home/work"
ENV LOG_LEVEL="INFO"

ENTRYPOINT ["python"]
CMD ["worker.py"]
