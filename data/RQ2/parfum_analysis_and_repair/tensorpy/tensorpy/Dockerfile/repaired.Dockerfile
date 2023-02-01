# TensorPy Docker Image
FROM ubuntu:17.10

#================================
# Update apt-get package sources
#================================
RUN apt-get update && apt-get -qy --no-install-recommends install \
    python \
    python-dev \
    python-pip \
    python-distribute \
    python-virtualenv \
    python-setuptools \
    sudo \
    unzip \
    wget \
    curl \
    libxi6 \
    libgconf-2-4 \
    vim \
    git-core \
  && rm -rf /var/lib/apt/lists/*#==================================================
# Install Bash Command Line Tools, Python, and Git
#==================================================

















#==============================
# Set up TensorFlow / TensorPy
#==============================
COPY install.sh /TensorPy/install.sh
COPY requirements.txt /TensorPy/
COPY setup.py /TensorPy/
COPY tensorpy /TensorPy/tensorpy/
COPY examples /TensorPy/examples/
COPY integrations/docker/run_docker_test.sh /TensorPy/
RUN cd /TensorPy && ls && ./install.sh
RUN cd /TensorPy && pip install --no-cache-dir -r requirements.txt

#===================
# Create entrypoint
#===================
COPY integrations/docker/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
