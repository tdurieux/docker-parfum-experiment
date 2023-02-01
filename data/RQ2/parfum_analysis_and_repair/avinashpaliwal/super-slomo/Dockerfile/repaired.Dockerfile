FROM nvidia/cuda:10.2-cudnn7-devel
RUN apt update && apt install --no-install-recommends python3 python3-pip ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir torch torchvision
RUN pip3 install --no-cache-dir numpy tqdm opencv-python
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip
