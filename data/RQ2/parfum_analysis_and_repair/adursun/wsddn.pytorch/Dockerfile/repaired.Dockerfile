FROM nvidia/cuda:10.1-devel-ubuntu18.04

WORKDIR /ws

COPY requirements.txt /ws/

RUN apt update && apt install --no-install-recommends -y apt-utils git vim libsm6 libxext6 libxrender-dev python3 python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r requirements.txt
RUN echo 'alias python="python3"' >> ~/.bashrc
RUN echo 'alias pip="pip3"' >> ~/.bashrc
