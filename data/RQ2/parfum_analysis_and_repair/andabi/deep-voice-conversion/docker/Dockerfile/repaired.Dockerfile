FROM tensorflow/tensorflow:1.8.0-gpu
MAINTAINER Guang Yang <garry.yangguang@gmail.com>

RUN apt-get update -y && apt-get install --no-install-recommends -y \
  sox \
  libsndfile1-dev \
  git \
  ffmpeg \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


ADD pip-requirements.txt /pip-requirements.txt
RUN pip install --no-cache-dir -r /pip-requirements.txt
