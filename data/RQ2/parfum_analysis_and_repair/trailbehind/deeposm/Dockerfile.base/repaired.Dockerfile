FROM tensorflow/tensorflow:0.8.0

WORKDIR /DeepOSM

# install required packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
         libjpeg-dev \
					software-properties-common \
         git cmake build-essential wget \
					libboost-all-dev libbz2-dev && rm -rf /var/lib/apt/lists/*;

# install python-gdal
RUN add-apt-repository ppa:ubuntugis/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends -y python-gdal && rm -rf /var/lib/apt/lists/*;

# install libosmium and pyosmium bindings
RUN git clone https://github.com/osmcode/libosmium.git /libosmium && \
    cd /libosmium && mkdir build && cd build && cmake .. && make && \
    git clone https://github.com/osmcode/pyosmium.git /pyosmium && \
    cd /pyosmium && pwd && python setup.py install

# install other python packages using pip
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# install s3cmd, used to ls the RequesterPays bucket
RUN wget https://netix.dl.sourceforge.net/project/s3tools/s3cmd/1.6.0/s3cmd-1.6.0.tar.gz && tar xvfz s3cmd-1.6.0.tar.gz && cd s3cmd-1.6.0 && python setup.py install && rm s3cmd-1.6.0.tar.gz

# copy s3cmd config defaults to docker, which will later be
# updated with AWS credentials by Python inside docker
COPY s3config-default /root/.s3cfg

# add code
ADD . /DeepOSM

# set up some paths
ENV PYTHONPATH /DeepOSM:/DeepOSM/src:$PYTHONPATH
ENV GEO_DATA_DIR /DeepOSM/data

# default command is to just open a bash shell
CMD /bin/bash
