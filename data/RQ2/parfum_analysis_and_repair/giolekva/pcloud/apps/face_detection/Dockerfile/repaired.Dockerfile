FROM ubuntu:20.04

# RUN pip install torch --no-cache-dir
# RUN pip install torchvision --no-cache-dir
# RUN pip install facenet-pytorch --no-cache-dir
# RUN pip install opencv-python-headless --no-cache-dir
# RUN pip install matplotlib --no-cache-dir

# RUN pip install numpy

RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
    python3 \
    python3-numpy \
    python3-opencv && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY *.py /app/
COPY *.xml /app/
