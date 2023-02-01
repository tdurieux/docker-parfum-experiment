#
# Debian Jessie Desktop (MATE) Dockerfile with QGIS
#
# https://github.com/DigitalGlobe/debian-desktop
#
# Pull base image.
# FROM x11docker/mate
# FROM debian:stretch
FROM debian:buster
#
# To run on a laptop.
# Demoes Python and TensorFlow.
# With VNC, and jupyter
#
# Updated June 2020
#
LABEL maintainer="Olivier LeDiouris <olivier@lediouris.net>"
#
# Uncomment if running behind a firewall (also set the proxies at the Docker level to the values below)
#ENV http_proxy http://www-proxy-hqdc.us.oracle.com:80
#ENV https_proxy http://www-proxy-hqdc.us.oracle.com:80
## ENV ftp_proxy $http_proxy
#ENV no_proxy "localhost,127.0.0.1,orahub.oraclecorp.com,artifactory-slc.oraclecorp.com"
#
RUN \
  apt-get update && \
  apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --fix-missing -y mate-desktop-environment-core curl git build-essential default-jdk sysvbanner vim tightvncserver && \
  rm -rf /var/lib/apt/lists/*
#
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y procps net-tools wget && rm -rf /var/lib/apt/lists/*;
#
RUN echo "deb http://qgis.org/debian jessie main" >> /etc/apt/sources.list
RUN mkdir ~/.vnc && echo "mate" | vncpasswd -f >> ~/.vnc/passwd && chmod 600 ~/.vnc/passwd
#
RUN apt-get install --no-install-recommends -y chromium && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://qgis.org/debian jessie main" >> /etc/apt/sources.list
#
# RUN apt-get install -y python-pip python-dev
RUN apt-get install --no-install-recommends -y python3-pip python3-dev python3-venv && rm -rf /var/lib/apt/lists/*;
#
# RUN pip3 install tensorflow-gpu
# RUN pip3 install tensorflow
RUN pip3 install --no-cache-dir tensorflow==2.0.0b1
#
# Uncomment if a suitable version exists...
# RUN pip3 install tensorflowjs
#
RUN pip3 install --no-cache-dir pandas numpy scipy scikit-learn
#
RUN apt-get install --no-install-recommends -y cmake unzip pkg-config libopenblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-numpy python-scipy python-matplotlib python-yaml && rm -rf /var/lib/apt/lists/*;
RUN python3 -mpip install matplotlib
#
RUN apt-get install --no-install-recommends -y libhdf5-serial-dev python-h5py && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pydot-ng
#
RUN apt-get install --no-install-recommends -y inkscape && rm -rf /var/lib/apt/lists/*;
#
RUN pip3 install --no-cache-dir jupyter
#
RUN apt-get install --no-install-recommends -y python-opencv && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-tk && rm -rf /var/lib/apt/lists/*;
#
EXPOSE 5901
EXPOSE 8888
#
# RUN pip install keras
#
# Install PyCharm community edition. Comment the 2 following lines if not needed.
# RUN wget --quiet https://download.jetbrains.com/python/pycharm-community-2018.2.4.tar.gz
RUN wget --quiet https://download.jetbrains.com/python/pycharm-community-2020.1.2.tar.gz -O pycharm.tar.gz
RUN tar xzf pycharm.tar.gz -C /opt/ && rm pycharm.tar.gz
# On Ubuntu, use ~/.bash_aliases, on Debian, use ~/.bashrc
RUN echo "alias ll='ls -lisah'" >> $HOME/.bashrc
#
RUN echo "banner TensorFlow" >> $HOME/.bashrc
RUN echo "git --version" >> $HOME/.bashrc
RUN echo "echo -n 'node:' && node -v" >> $HOME/.bashrc
RUN echo "echo -n 'npm:' && npm -v" >> $HOME/.bashrc
RUN echo "java -version" >> $HOME/.bashrc
RUN echo "vncserver -version" >> $HOME/.bashrc
# lsb_release: Full Linux version with details.
RUN echo "lsb_release -a" >> $HOME/.bashrc
RUN echo "echo -n 'Python3:' && python3 -V" >> $HOME/.bashrc
RUN echo "echo -n 'Keras:' && python3 -c 'import keras; print(keras.__version__)'" >> $HOME/.bashrc
RUN echo "echo -n 'Jupyter:' && jupyter --version" >> $HOME/.bashrc
RUN echo "echo '---------------------------------------------------------------------'" >> $HOME/.bashrc
RUN echo "echo 'To start VNCserver, type: vncserver :1 -geometry 1280x800 -depth 24'" >> $HOME/.bashrc
RUN echo "echo '                       or vncserver :1 -geometry 1440x900 -depth 24'" >> $HOME/.bashrc
RUN echo "echo '                       or vncserver :1 -geometry 1680x1050 -depth 24 , ...etc.'" >> $HOME/.bashrc
RUN echo "echo '---------------------------------------------------------------------'" >> $HOME/.bashrc
RUN echo "echo 'To start Jupyter, type: jupyter-notebook --allow-root --ip 0.0.0.0 --no-browser'" >> $HOME/.bashrc
RUN echo "echo '  - Default port 8888 is exposed, you can use from the host http://localhost:8888/?token=6c95d878c045212bxxxxxx'" >> $HOME/.bashrc
RUN echo "echo '---------------------------------------------------------------------'" >> $HOME/.bashrc
RUN echo "echo 'To run PyCharm: cd /opt/pycharm-community-20.../bin and run ./pycharm.sh'"  >> $HOME/.bashrc
RUN echo "echo '---------------------------------------------------------------------'" >> $HOME/.bashrc
RUN echo "echo '>> Warning: To run Chrome: $ chromium --no-sandbox '"  >> $HOME/.bashrc
RUN echo "echo '---------------------------------------------------------------------'" >> $HOME/.bashrc
#
USER root
WORKDIR /root
RUN mkdir workdir
WORKDIR /root/workdir
#
RUN git clone https://github.com/fchollet/keras
WORKDIR /root/workdir/keras
RUN python3 setup.py install
#
# Jupyter notebooks from "Deep Learning with Python"
RUN git clone https://github.com/fchollet/deep-learning-with-python-notebooks.git
# repo from "Deep Learning Crash Course"
RUN git clone https://github.com/DJCordhose/deep-learning-crash-course-notebooks
#
RUN mkdir ./examples/oliv
# From local file system to image
COPY ./tensorflow ./examples/oliv
#    |            |
#    |            In the Docker image
#    On the host (this machine)
#
#
WORKDIR /root/workdir
RUN git clone https://github.com/OlivierLD/oliv-ai.git
#
WORKDIR /root/workdir/oliv-ai/JupyterNotebooks/deep.learning.crash.course
#
ENV http_proxy ""
ENV https_proxy ""
ENV no_proxy ""
#ENV http_proxy http://www-proxy-hqdc.us.oracle.com:80
#ENV https_proxy http://www-proxy-hqdc.us.oracle.com:80
## ENV ftp_proxy $http_proxy
#ENV no_proxy "localhost,127.0.0.1,orahub.oraclecorp.com,artifactory-slc.oraclecorp.com"
#
CMD ["echo", "Happy TensorFlowing!"]
