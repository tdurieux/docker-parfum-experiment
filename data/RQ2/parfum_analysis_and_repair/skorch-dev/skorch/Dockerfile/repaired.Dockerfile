FROM nvidia/cuda:9.0-cudnn7-runtime

RUN apt-get update && \
	apt-get install --no-install-recommends -y python3.5-dev vim git g++ sudo zip python3-setuptools && rm -rf /var/lib/apt/lists/*;
RUN easy_install3 --upgrade pip setuptools

ENV PIP_CACHE_DIR=/cache PYTHONDONTWRITEBYTECODE=1

RUN pip3 install --no-cache-dir torch
RUN pip3 install --no-cache-dir torchvision

WORKDIR /app

ADD requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

ADD . /app
RUN pip3 install --no-cache-dir -e .
