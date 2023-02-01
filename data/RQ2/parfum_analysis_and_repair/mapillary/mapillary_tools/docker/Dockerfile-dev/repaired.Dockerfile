FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt install --no-install-recommends -y python3 python3-pip git && apt install -y --no-install-recommends ffmpeg && rm -rf /var/lib/apt/lists/*;

WORKDIR /mapillary_tools
ADD requirements.txt requirements-dev.txt /mapillary_tools
RUN python3 -m pip install -r requirements.txt -r requirements-dev.txt
ADD . /mapillary_tools
