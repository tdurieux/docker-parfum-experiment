FROM python:3.7 AS base

RUN apt-get update && apt-get install --no-install-recommends -y python3-opencv && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir opencv-python tensorflow==1.15.0 Pillow matplotlib

WORKDIR /app

COPY . /app

ADD http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_coco_2018_03_29.tar.gz /app/ssd_mobilenet_v2_coco_2018_03_29.tar.gz

RUN tar -zxf ssd_mobilenet_v2_coco_2018_03_29.tar.gz && rm ssd_mobilenet_v2_coco_2018_03_29.tar.gz

RUN pip3 install --no-cache-dir matplotlib eventlet

RUN pip3 install --no-cache-dir flask Flask-SocketIO==4.3.1 python-socketio==4.3.1 python-engineio==3.14.2

RUN ls -lh
