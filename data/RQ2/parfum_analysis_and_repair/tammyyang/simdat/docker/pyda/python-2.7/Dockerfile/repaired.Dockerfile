FROM cudnn:v4

RUN apt-get update
RUN apt-get upgrade -y
# basic tools
RUN apt-get install --no-install-recommends -y openssh-server git-core curl wget vim-tiny build-essential python-dev python-setuptools && rm -rf /var/lib/apt/lists/*;

# compilers
RUN apt-get install --no-install-recommends -y gfortran build-essential make gcc build-essential && rm -rf /var/lib/apt/lists/*;

# install python
RUN apt-get install --no-install-recommends -y python2.7 python2.7-dev python-pip && rm -rf /var/lib/apt/lists/*;

# python-PIL
RUN apt-get install --no-install-recommends -y python-pil && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-httplib2 ipython && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-numpy python-scipy python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libatlas-dev libatlas3gf-base && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-skimage python-matplotlib python-pandas && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-h5py && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir scikit-learn

# install opencv 2.4.12
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
RUN cd ~ && \
    mkdir -p src && \
    cd src && \
    curl -f -L https://github.com/Itseez/opencv/archive/2.4.12.zip -o ocv.zip && \
    unzip ocv.zip && \
    cd opencv-2.4.12 && \
    mkdir release && \
    cd release && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D BUILD_PYTHON_SUPPORT=ON \
          .. && \
    make -j8 && \
    make install

RUN sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
RUN ldconfig

EXPOSE 8888
