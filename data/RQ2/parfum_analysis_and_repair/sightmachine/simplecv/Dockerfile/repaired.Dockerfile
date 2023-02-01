# Build with
# sudo docker -t="simplecv" .
# Run with
# sudo docker run -p 54717:8888 -t -i simplecv

FROM ubuntu:12.04

MAINTAINER Anthony Oliver <anthony@sightmachine.com>

# Install system dependencies
RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python2.7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python2.7-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py -O - | python

# SimpleCV Specific
RUN apt-get install --no-install-recommends -y libopencv-* && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-opencv && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-scipy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pygame && rm -rf /var/lib/apt/lists/*;
# RUN pip install PIL
RUN pip install --no-cache-dir ipython
RUN pip install --no-cache-dir pyzmq
RUN pip install --no-cache-dir jinja2
RUN pip install --no-cache-dir tornado

# SimpleCV Install
RUN wget https://github.com/sightmachine/SimpleCV/archive/master.zip
RUN unzip master
RUN cd SimpleCV-master; pip install --no-cache-dir -r requirements.txt; python setup.py install

# Use clang
ENV CC clang
ENV CXX clang++

# Environment setup
EXPOSE 8888
ENV USER docker
WORKDIR /home/docker

# Setup the notebook
RUN echo 'ipython notebook --ip=0.0.0.0 --port=8888 --no-browser'  >> start.sh
RUN chmod +x start.sh
CMD bash -C '/home/docker/start.sh';'bash'