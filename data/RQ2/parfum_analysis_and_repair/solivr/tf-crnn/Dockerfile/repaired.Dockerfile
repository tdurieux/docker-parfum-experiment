FROM tensorflow/tensorflow:1.8.0-gpu

# Python version
RUN python -v

# Additional requirements from Tensorflow
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-dev && rm -rf /var/lib/apt/lists/*;

# Clean up Python 3 install
RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

# Instal Notebook
RUN pip3 install --no-cache-dir ipython notebook

# Install tensorflow 1.8.0 (Does not actually work in 1.7.0)
RUN pip3 install --no-cache-dir tensorflow-gpu==1.8.0

# Copy and install TF-CRNN

ADD . /script
WORKDIR /script
RUN python3 setup.py install

# Add an additional sources directory
# You should normalize the filepath in your data
VOLUME /sources
VOLUME /config

# TensorBoard
EXPOSE 6006
# Allowing tensorflow to run and be read
EXPOSE 8888