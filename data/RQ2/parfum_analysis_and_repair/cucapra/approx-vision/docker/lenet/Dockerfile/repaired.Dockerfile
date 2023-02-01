FROM kaixhin/cuda-caffe:7.0
WORKDIR /root

# Install wget and python-dev
RUN apt-get install --no-install-recommends wget python-dev -y && rm -rf /var/lib/apt/lists/*;

# Install vim (for my sanity)
RUN apt-get install --no-install-recommends vim -y && rm -rf /var/lib/apt/lists/*;

# Install numpy for data analyis
RUN pip install --no-cache-dir numpy easydict

# Install Faster RCNN dependencies
RUN apt-get install --no-install-recommends cmake cython python-opencv -y && rm -rf /var/lib/apt/lists/*;

# Clone the automation script and copy it to caffe
WORKDIR /root
RUN git clone https://github.com/mbuckler/lenet-script.git
RUN cp lenet-script/run-lenet.py /root/caffe/

# Start user in the caffe directory
WORKDIR /root/caffe
