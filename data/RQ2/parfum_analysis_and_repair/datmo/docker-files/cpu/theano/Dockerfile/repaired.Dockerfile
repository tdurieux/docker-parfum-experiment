FROM ubuntu:14.04
MAINTAINER Datmo devs <dev@datmo.io>
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-numpy \
    python-scipy \
    python-dev \
    python-nose \
    g++ \
    libopenblas-dev \
    git \
    curl \
    cmake && rm -rf /var/lib/apt/lists/*;

RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install Theano

# Install other useful Python packages using pip
RUN pip --no-cache-dir install --upgrade ipython && \
	pip --no-cache-dir install \
		Cython \
		ipykernel \
		jupyter \
		path.py \
		Pillow \
		pygments \
		six \
		sphinx \
		wheel \
		zmq \
		&& \
	python -m ipykernel.kernelspec

# Install OpenCV
RUN apt-get update && apt-get install --no-install-recommends -y libopencv-dev python-opencv && \
    echo 'ln /dev/null /dev/raw1394' >> ~/.bashrc && rm -rf /var/lib/apt/lists/*;

# Jupyter notebook related configs
COPY jupyter_notebook_config.py /root/.jupyter/
EXPOSE 8888

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
COPY run_jupyter.sh /home/

#Adding flask
RUN pip install --no-cache-dir flask
EXPOSE 5000

WORKDIR /workspace
RUN chmod -R a+w /workspace
