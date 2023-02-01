FROM ubuntu:20.04

RUN apt-get update && apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install -y --no-install-recommends python3.8-dev python3-pip libsm6 libxext6 build-essential ffmpeg libsm6 libxext6 tesseract-ocr && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir pillow
RUN pip3 install --no-cache-dir pytesseract
RUN pip3 install --no-cache-dir opencv-contrib-python


# Copy project
COPY ./ ./

RUN pip3 install --no-cache-dir -r requirements.txt


ENTRYPOINT ["./run.sh"]
CMD []
