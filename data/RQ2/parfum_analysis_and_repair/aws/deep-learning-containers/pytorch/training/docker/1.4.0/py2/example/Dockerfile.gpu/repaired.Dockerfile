# Use the Deep Learning Container as a base Image
ARG BASE_IMAGE=""

FROM $BASE_IMAGE

RUN pip install --no-cache-dir tensorboardX==1.6.0

# Add any script or repo as required
RUN cd /var && wget https://raw.githubusercontent.com/kubeflow/pytorch-operator/master/examples/mnist/mnist.py

ENTRYPOINT ["python", "/var/mnist.py"]
