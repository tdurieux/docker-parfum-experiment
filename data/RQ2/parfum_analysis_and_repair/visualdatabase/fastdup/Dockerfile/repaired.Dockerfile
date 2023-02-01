FROM ubuntu:20.04
RUN apt update
RUN apt -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt update
RUN apt -y --no-install-recommends install python3.8 && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install libopencv-dev libgl1 && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3.8 -m pip install --upgrade pip
RUN python3.8 -m pip install fastdup matplotlib matplotlib-inline torchvision pillow pyyaml
