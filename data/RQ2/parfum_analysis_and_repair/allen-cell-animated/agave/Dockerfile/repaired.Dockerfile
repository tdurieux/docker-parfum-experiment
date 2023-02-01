### Build image ###
FROM nvidia/cudagl:11.2.2-devel-ubuntu18.04 as build

# install dependencies
RUN mkdir /agave && \
    mkdir /agave/build && \
    apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    build-essential \
    git \
    wget \
    libspdlog-dev \
    libtiff-dev \
    libglm-dev \
    libgl1-mesa-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    libegl1 \
    xvfb \
    xauth && rm -rf /var/lib/apt/lists/*;

# get a current cmake
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https ca-certificates gnupg software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --batch --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
RUN apt-get install -y --no-install-recommends kitware-archive-keyring && rm -rf /var/lib/apt/lists/*;
RUN rm /etc/apt/trusted.gpg.d/kitware.gpg
RUN apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

# get python
RUN apt-get install --no-install-recommends -y python3.8-dev python3-pip && rm -rf /var/lib/apt/lists/*;

# get Qt installed
ENV QT_VERSION=5.15.2
RUN pip3 install --no-cache-dir aqtinstall
RUN aqt install --outputdir /qt ${QT_VERSION} linux desktop gcc_64

# required for qt offscreen platform plugin
RUN apt-get install --no-install-recommends -y libfontconfig && rm -rf /var/lib/apt/lists/*;

# copy agave project
COPY . /agave
RUN rm -rf /agave/build/*
WORKDIR /agave

# install submodules
RUN git submodule update --init --recursive

# build agave project
ENV QTDIR=/qt/${QT_VERSION}/gcc_64
RUN cd ./build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make

# leaving this here to show how to load example data into docker image
# RUN mkdir /agavedata
# RUN cp AICS-11_409.ome.tif /agavedata/
# RUN cp AICS-12_881.ome.tif /agavedata/
# RUN cp AICS-13_319.ome.tif /agavedata/

EXPOSE 1235

COPY docker-entrypoint.sh /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/docker-entrypoint.sh"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]