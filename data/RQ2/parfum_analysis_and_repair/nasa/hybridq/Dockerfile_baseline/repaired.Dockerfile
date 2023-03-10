# Get baseline
FROM quay.io/pypa/manylinux2014_x86_64

# Update baseline
RUN yum -y update && \
    yum -y upgrade && \
    yum install -y openmpi-devel devtoolset-11-gcc-c++.x86_64 && \
    yum clean all -y && rm -rf /var/cache/yum

# Get Python version
ARG PYTHON_VERSION

# Set default if needed. Available versions
# cp37-cp37m
# cp38-cp38
# cp39-cp39
# cp310-cp310
ENV PYTHON_VERSION=${PYTHON_VERSION:-cp37-cp37m}
ENV PYTHON=/opt/python/${PYTHON_VERSION}/bin/python

# Update path
ENV PATH=/usr/lib64/openmpi/bin:$PATH

# Update LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=/opt/python/${PYTHON_VERSION}/lib/:/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH

# Upgrade PIP
RUN $PYTHON -m pip install --no-cache --upgrade pip

# Install MPI4Py
RUN $PYTHON -m pip install --no-cache mpi4py

# Install JupyterLab
RUN $PYTHON -m pip install --no-cache jupyter notebook

# Install PaperMill
RUN $PYTHON -m pip install --no-cache papermill

# Copy requirements
COPY requirements.txt /tmp/

# Install requirements
RUN $PYTHON -m pip install --no-cache \
                      -r /tmp/requirements.txt \
                      scipy~=1.7 \
                      numpy~=1.21

# Remove requirements file
RUN rm /tmp/requirements.txt
