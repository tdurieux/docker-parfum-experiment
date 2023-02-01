FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN unattended-upgrade
RUN apt-get autoremove -y

RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir sphinx
RUN pip install --no-cache-dir recommonmark
RUN pip install --no-cache-dir pytorch_sphinx_theme
RUN pip install --no-cache-dir torch

RUN pip install --no-cache-dir --pre onnxruntime-training -f https://download.onnxruntime.ai/onnxruntime_nightly_cpu.html
RUN pip install --no-cache-dir torch-ort
RUN python -m torch_ort.configure
