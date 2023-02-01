FROM python:3.8

WORKDIR /home

RUN apt update

# Required by OpenCV
RUN apt install --no-install-recommends libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gfortran libopenblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*;

## Install applications dependencies
RUN pip install --no-cache-dir torch torchvision tqdm pillow opencv-python pytorch-ignite asyncio

## Install Kafka Python library
RUN pip install --no-cache-dir kafka-python

## Add tracking dependencies
RUN pip install --no-cache-dir lap scipy Cython
RUN pip install --no-cache-dir cython_bbox

## Install S3 library
RUN pip install --no-cache-dir boto3

# ONNX
RUN pip install --no-cache-dir onnx protobuf==3.16.0

WORKDIR /home

## SEDNA SECTION ##

COPY ./lib/requirements.txt /home
RUN pip install --no-cache-dir -r /home/requirements.txt

ENV PYTHONPATH "${PYTHONPATH}:/home/lib"

WORKDIR /home/work
COPY ./lib /home/lib

COPY examples/multiedgeinference/pedestrian_tracking/detection  /home/work/

ENV LOG_LEVEL="DEBUG"

ENTRYPOINT ["python"]
CMD ["worker.py"]
