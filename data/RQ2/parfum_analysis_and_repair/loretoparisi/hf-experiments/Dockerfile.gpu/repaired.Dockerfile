#
# hf-experiments
# @author Loreto Parisi (loretoparisi at gmail dot com)
# Copyright (c) 2020-2021 Loreto Parisi (loretoparisi at gmail dot com)
#

FROM pytorch/pytorch:1.8.1-cuda11.1-cudnn8-runtime

LABEL maintainer Loreto Parisi loretoparisi@gmail.com

WORKDIR app

COPY src .

# system-wide dependencies
# lam4-dev gcc needed for deepspeed
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    software-properties-common \
    libsndfile1-dev \
    curl && \
    add-apt-repository ppa:jonathonf/ffmpeg-4 && \
    apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;

# system-wide python requriments
RUN pip3 install --no-cache-dir -r requirements-gpu.txt

# utils
RUN pip3 install --no-cache-dir -r lpdutils/requirements.txt

# experiment-wide python requriments
RUN pip3 install --no-cache-dir -r asr/requirements.txt
#RUN pip3 install -r asr/requirements.deepspeed.txt
RUN pip3 install --no-cache-dir -r genre/requirements.txt
RUN pip3 install --no-cache-dir -r audioset/requirements.txt
RUN pip3 install --no-cache-dir -r audioseg/requirements.txt
RUN pip3 install --no-cache-dir -r mlpvision/requirements.txt
RUN pip3 install --no-cache-dir -r skweak/requirements.txt
RUN pip3 install --no-cache-dir -r pokemon/requirements.txt
RUN pip3 install --no-cache-dir -r projected_gan/requirements.txt
RUN pip3 install --no-cache-dir -r fasttext/requirements.txt

CMD ["bash"]