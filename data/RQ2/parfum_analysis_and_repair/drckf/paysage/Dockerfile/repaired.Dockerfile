FROM pytorch/pytorch

# Needed to avoid debconf Display errors
ENV DEBIAN_FRONTEND noninteractive

# System Dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir cython

RUN /opt/conda/bin/conda install numpy pyyaml scipy ipython mkl mkl-include && \
    /opt/conda/bin/conda install -c pytorch magma-cuda90 && \
    /opt/conda/bin/conda clean -ya

# Add repo to container
ADD . /opt/paysage

# Install dependencies
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --ignore-installed -r /opt/paysage/requirements.txt

# Install pytorch
# (torch wheel already included in pytorch docker image)
RUN pip install --no-cache-dir torchvision

# Install paysage
RUN pip install --no-cache-dir -e /opt/paysage/

# Download MNIST
RUN python /opt/paysage/examples/mnist/download_mnist.py

# Test
CMD pytest /opt/paysage/test/test_backends.py
