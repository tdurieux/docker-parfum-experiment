FROM tensorflow/tensorflow:1.15.2-gpu-py3

RUN apt update \
 && apt install --no-install-recommends -y \
        git \
        ffmpeg libsm6 libxext6 \
        wget \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/tensorflow/models.git /models

WORKDIR /models/research/object_detection

RUN wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip \
 && unzip -p protobuf.zip bin/protoc > /usr/bin/protoc \
 && chmod +x /usr/bin/protoc \
 && cd ../ \
 && protoc object_detection/protos/*.proto --python_out=.

RUN pip3 install --no-cache-dir Cython contextlib2 matplotlib pillow lxml minio requests tf_slim scipy lvis

ENV PYTHONPATH "${PYTHONPATH}:/models/research/:/models/research/slim"

CMD ['python', 'object_detection/builders/model_builder_test.py']
