# Use the Deep Learning Container as a base Image
ARG BASE_IMAGE=""

FROM $BASE_IMAGE

RUN pip install --no-cache-dir tensorboardX==1.6.0

# Add any script or repo as required
COPY mnist.py /var/mnist.py

ENTRYPOINT ["python", "/var/mnist.py"]
