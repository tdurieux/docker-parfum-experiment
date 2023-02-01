FROM python:3.8

WORKDIR /home

## Install git
RUN apt update

# Required by OpenCV
RUN apt install --no-install-recommends libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y gfortran libopenblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*;

## Install application dependencies
RUN pip install --no-cache-dir torch tqdm pillow opencv-python pytorch-ignite

## Add Kafka Python library
RUN pip install --no-cache-dir kafka-python

## Install S3 library
RUN pip install --no-cache-dir boto3

## SEDNA SECTION ##
COPY ./lib/requirements.txt /home
RUN pip install --no-cache-dir -r /home/requirements.txt

ENV PYTHONPATH "${PYTHONPATH}:/home/lib"

WORKDIR /home/work
COPY ./lib /home/lib

COPY examples/multiedgeinference/pedestrian_tracking/reid /home/work/

ENV LOG_LEVEL="INFO"

ENTRYPOINT ["python"]
CMD ["worker.py"]
