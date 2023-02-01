FROM nvidia/cuda:11.2.0-cudnn8-devel-ubuntu18.04

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install all dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    software-properties-common \
    curl \
    ffmpeg \
    git \
    libasound2-dev \
    libmagic-dev \
    libopenmpi-dev \
    libsndfile-dev \
    openmpi-bin \
    rsync \
    ssh \
    wget \
    && add-apt-repository universe \
    && apt-get update \
    && apt-get -y --no-install-recommends install python3.7 python3.7-gdbm python3-distutils \
    && curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3.7 get-pip.py \
    && ln -s /usr/local/cuda-11.2/targets/x86_64-linux/lib/libcudart.so.11.0 /usr/lib/x86_64-linux-gnu/libcudart.so.11.0 && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /webapp/media /webapp/staticfiles

WORKDIR /webapp
COPY requirements.txt /webapp/
RUN pip3 install --no-cache-dir torch==1.8.1+cu111 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip3 install --no-cache-dir --upgrade pip -r requirements.txt

COPY . .

COPY api-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/api-entrypoint.sh && ln -s /usr/local/bin/api-entrypoint.sh /

ENTRYPOINT ["api-entrypoint.sh"]
