# docker can be installed on the dev board following these instructions:
# https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-repository , step 4: x86_64 / amd64
# 1) build: docker build -t "neuralet/amd64:efficientnet-edgetpu-S" .
# 2) run: docker run -it --privileged --net=host -v /PATH_TO_CLONED_REPO_ROOT/:/repo neuralet/amd64:efficientnet-edgetpu-S

FROM amd64/debian:buster

VOLUME  /repo

RUN apt-get update && apt-get install --no-install-recommends -y wget gnupg usbutils && rm -rf /var/lib/apt/lists/*;

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list
RUN wget -qO - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip pkg-config libedgetpu1-std python3-wget && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp37-cp37m-linux_x86_64.whl

WORKDIR /repo/amd64/efficientnet-edgetpu-S

ENTRYPOINT ["python3", "src/server-example.py"]
