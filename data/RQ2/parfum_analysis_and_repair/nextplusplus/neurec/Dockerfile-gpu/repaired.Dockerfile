FROM tensorflow/tensorflow:1.12.3-gpu-py3

LABEL maintainer="jonathanstaniforth@gmail.com"

RUN apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends -y python3.6 && rm -rf /var/lib/apt/lists/*;

WORKDIR /tf/neurec

COPY . .

RUN pip3 install --no-cache-dir neurec && \
    pip3 install --no-cache-dir -r requirements.txt

WORKDIR /tf

EXPOSE 8888