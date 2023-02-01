FROM nvcr.io/nvidia/tensorflow:19.10-py3
MAINTAINER OCR-D
ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONIOENCODING utf8

WORKDIR /build-layouterkennung
COPY setup.py .
COPY requirements.txt .
COPY README.md .
COPY ocrd_anybaseocr ./ocrd_anybaseocr
RUN pip3 install .

ENTRYPOINT ["/bin/sh", "-c"]
