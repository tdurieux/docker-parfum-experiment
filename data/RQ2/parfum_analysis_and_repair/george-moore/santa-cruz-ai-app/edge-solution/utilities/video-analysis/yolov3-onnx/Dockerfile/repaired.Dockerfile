# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

FROM ubuntu:18.04

# Copy the app file and the tags file
RUN mkdir /app
COPY app/yolov3-app.py /app
COPY  tags.txt /app

# Install python
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends python3-pip python3-dev && \
    cd /usr/local/bin && \
    ln -s /usr/bin/python3 python && \
    pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

# Install python packages
RUN pip install --no-cache-dir numpy onnxruntime flask pillow gunicorn requests && \
    apt-get clean

# Install runit, nginx
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y wget runit nginx && rm -rf /var/lib/apt/lists/*;

# Install Nchan module. For details goto http://nchan.io
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y libnginx-mod-nchan && rm -rf /var/lib/apt/lists/*;

# Download the model
RUN cd /app && \
    wget https://github.com/onnx/models/raw/master/vision/object_detection_segmentation/yolov3/model/yolov3-10.tar.gz && \
    tar -xzf yolov3-10.tar.gz && \
    rm -rf yolov3-10.tar.gz && \
    rm -rf test_data_set_0/* && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get purge -y --auto-remove wget

# Copy nginx config file
COPY yolov3-app.conf /etc/nginx/sites-available

# Setup runit file for nginx and gunicorn
RUN mkdir /var/runit && \
    mkdir /var/runit/nginx && \
    /bin/bash -c "echo -e '"'#!/bin/bash\nexec nginx -g "daemon off;"\n'"' > /var/runit/nginx/run" && \
    chmod +x /var/runit/nginx/run && \
    ln -s /etc/nginx/sites-available/yolov3-app.conf /etc/nginx/sites-enabled/ && \
    rm -rf /etc/nginx/sites-enabled/default && \
    mkdir /var/runit/gunicorn && \
    /bin/bash -c "echo -e '"'#!/bin/bash\nexec gunicorn -b 127.0.0.1:8000 --chdir /app yolov3-app:app\n'"' > /var/runit/gunicorn/run" && \
    chmod +x /var/runit/gunicorn/run

EXPOSE 80

# Start runsvdir
CMD ["runsvdir","/var/runit"]