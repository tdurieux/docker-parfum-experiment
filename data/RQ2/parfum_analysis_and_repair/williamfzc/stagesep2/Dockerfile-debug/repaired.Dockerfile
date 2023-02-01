FROM python:3-slim

USER root

WORKDIR /usr/src/app
COPY . .

RUN apt-get update \
    && apt-get -y --no-install-recommends install gcc build-essential tesseract-ocr tesseract-ocr-chi-sim libtesseract-dev libleptonica-dev pkg-config \
    && apt-get -y --no-install-recommends install libglib2.0 libsm6 libxrender1 libxext-dev \
    && pip install --no-cache-dir . \
    && apt-get purge -y --auto-remove gcc build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/stagesep2
CMD ["bash"]
