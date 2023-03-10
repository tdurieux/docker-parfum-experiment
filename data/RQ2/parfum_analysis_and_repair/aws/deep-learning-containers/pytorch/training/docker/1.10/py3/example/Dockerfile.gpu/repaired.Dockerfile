# Expecting base image to be the Deep Learning Container image built by ../cu113/Dockerfile.e3.gpu
ARG BASE_IMAGE=""

FROM $BASE_IMAGE

RUN pip install --no-cache-dir tensorboardX==2.4

# Add any script or repo as required
COPY mnist.py /var/mnist.py

ENTRYPOINT ["python", "/var/mnist.py"]
