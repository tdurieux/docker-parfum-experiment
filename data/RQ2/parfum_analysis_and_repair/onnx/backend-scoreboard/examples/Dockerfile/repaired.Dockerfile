##### SCOREBOARD DOCKERFILE TEMPLATE #####
FROM ubuntu:18.04

# Disable interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install Python dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-dev \
    python3-pip && \
    apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# Copy local directories
COPY ./test /root/test
COPY ./setup /root/setup

# Install test report dependencies
RUN pip3 install --no-cache-dir -r /root/setup/requirements_report.txt

############## ONNX Backend dependencies ###########
# EDIT HERE
ENV ONNX_BACKEND=""

# Install dependencies
RUN pip install --no-cache-dir onnx

####################################################

CMD . /root/setups/docker-setup.sh && \
    pytest /root/test/test_backend.py --onnx_backend=${ONNX_BACKEND} -k 'not _cuda' -v
