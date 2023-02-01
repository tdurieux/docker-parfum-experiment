FROM python:slim

RUN pip install --no-cache-dir lukeparser
RUN luke --init

ENV hostname=0.0.0.0
ENV root_dir="/home"
CMD ["luke-server"]
