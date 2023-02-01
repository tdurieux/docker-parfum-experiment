FROM tensorflow/tensorflow:1.8.0-gpu-py3
MAINTAINER Kiru Park (park@acin.tuwien.ac.at)
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install --no-install-recommends -y python3.5-dev python3-pip python3-tk vim git libgtk2.0-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /Pix2Pose
COPY . .
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt

