FROM cloudgear/ubuntu:14.04

MAINTAINER Datmo devs <dev@datmo.io>

RUN apt-get update; \
    apt-get install --no-install-recommends -y \
      python python-pip \
      build-essential \
      python-dev \
      python-setuptools \
      python-matplotlib \
      libatlas-dev \
      curl \
      libatlas3gf-base && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install pip
RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip install --no-cache-dir numpy==1.13.1
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir -U scikit-learn
RUN pip install --no-cache-dir seaborn
RUN pip install --no-cache-dir matplotlib
RUN pip install --no-cache-dir --pre xgboost

RUN update-alternatives --set libblas.so.3 \
      /usr/lib/atlas-base/atlas/libblas.so.3; \
    update-alternatives --set liblapack.so.3 \
     /usr/lib/atlas-base/atlas/liblapack.so.3

# Install CURL
RUN apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;

# Install other useful Python packages using pip
RUN apt-get update
RUN pip install --no-cache-dir --upgrade ipython && \
        pip install --no-cache-dir \
                ipykernel \
                jupyter \
                && \
        python -m ipykernel.kernelspec

#Jupyter notebook related configs
COPY jupyter_notebook_config.py /root/.jupyter/
EXPOSE 8888

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
COPY run_jupyter.sh /home/

RUN pip install --no-cache-dir flask
EXPOSE 5000
