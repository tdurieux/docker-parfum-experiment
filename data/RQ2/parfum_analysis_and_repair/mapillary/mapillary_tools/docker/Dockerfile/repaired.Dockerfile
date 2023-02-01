FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt install --no-install-recommends -y python3 python3-pip git && apt install -y --no-install-recommends ffmpeg && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --upgrade git+https://github.com/mapillary/mapillary_tools
