# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
FROM ubuntu:18.04

# Install python
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends python3-pip python3-dev libglib2.0-0 libsm6 libxext6 libxrender-dev&& \
    cd /usr/local/bin && \
    ln -s /usr/bin/python3 python && \
    pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

# Install python packages
RUN pip install --no-cache-dir numpy flask gunicorn requests opencv-python && \
    apt-get install --no-install-recommends -y libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;

# Copy the app file and the tags file
RUN mkdir /app
COPY ./app/*.py /app/

# Start http extension module
WORKDIR /app
ENTRYPOINT ["python3", "main.py"]
