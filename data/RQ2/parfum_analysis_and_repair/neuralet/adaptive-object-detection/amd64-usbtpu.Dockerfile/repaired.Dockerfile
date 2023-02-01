# docker can be installed on the dev board following these instructions:
# https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-repository , step 4: x86_64 / amd64
# 1) build: docker build -f Dockerfile-amd64-usbtpu -t "neuralet/amd64:applications-smart-distancing" .
# 2) run: docker run -it --privileged -p HOST_PORT:8000 -v /PATH_TO_CLONED_REPO_ROOT/:/repo neuralet/amd64:applications-smart-distancing

FROM amd64/debian:buster

VOLUME  /repo

RUN apt-get update && apt-get install --no-install-recommends -y wget gnupg usbutils && rm -rf /var/lib/apt/lists/*;

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list
RUN wget -qO - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip pkg-config libedgetpu1-std python3-wget python3-opencv python3-pillow edgetpu-compiler && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp37-cp37m-linux_x86_64.whl protobuf

RUN apt-get update && apt-get install --no-install-recommends -y python3-edgetpu zip vim && rm -rf /var/lib/apt/lists/*;
WORKDIR /repo/

