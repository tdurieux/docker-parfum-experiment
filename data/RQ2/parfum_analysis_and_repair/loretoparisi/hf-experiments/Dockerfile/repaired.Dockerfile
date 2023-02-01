#
# hf-experiments
# @author Loreto Parisi (loretoparisi at gmail dot com)
# Copyright (c) 2020-2021 Loreto Parisi (loretoparisi at gmail dot com)
#

FROM python:3.7.4-slim-buster

LABEL maintainer Loreto Parisi loretoparisi@gmail.com

WORKDIR app

COPY src .

# system-wide dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    software-properties-common \
    libsndfile1-dev \
    curl && \
    add-apt-repository ppa:jonathonf/ffmpeg-4 && \
    apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;

# system-wide python requriments
RUN pip3 install --no-cache-dir -r requirements-dev.txt

# utils
RUN pip3 install --no-cache-dir -r lpdutils/requirements.txt

# experiment-wide python requriments
RUN pip3 install --no-cache-dir -r asr/requirements.txt
RUN pip3 install --no-cache-dir -r genre/requirements.txt
RUN pip3 install --no-cache-dir -r audioset/requirements.txt
RUN pip3 install --no-cache-dir -r audioseg/requirements.txt
RUN pip3 install --no-cache-dir -r mlpvision/requirements.txt
RUN pip3 install --no-cache-dir -r skweak/requirements.txt
RUN pip3 install --no-cache-dir -r pokemon/requirements.txt
RUN pip3 install --no-cache-dir -r projected_gan/requirements.txt
RUN pip3 install --no-cache-dir -r fasttext/requirements.txt

CMD ["bash"]