FROM codercom/enterprise-base:centos

# Run everything as root
USER root

# Install required dependencies
RUN dnf install --assumeyes \
   platform-python-devel

# Install jupyter
RUN pip3 install --no-cache-dir jupyter-core==4.7.1 && \
    pip3 install --no-cache-dir jupyterlab

# Set back to coder user
USER coder
