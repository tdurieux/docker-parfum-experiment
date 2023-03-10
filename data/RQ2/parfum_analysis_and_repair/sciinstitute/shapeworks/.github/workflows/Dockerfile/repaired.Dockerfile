FROM ubuntu:xenial-20210429 AS env
MAINTAINER akenmorris@gmail.com


RUN apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get install --no-install-recommends build-essential software-properties-common -y && add-apt-repository ppa:ubuntu-toolchain-r/test -y && apt-get update -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gcc-9 g++-9 -y && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9 && update-alternatives --config gcc

ENV PATH=/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get install --no-install-recommends git curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get install --no-install-recommends git-lfs -y && rm -rf /var/lib/apt/lists/*;


RUN which git
RUN which git-lfs

RUN curl -f https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/Miniconda3-latest-Linux-x86_64.sh \
    && bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
    && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && conda update -n base -c defaults conda \
    && conda install pip \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "conda activate base" >> ~/.bashrc

RUN pip3 install --no-cache-dir --upgrade aqtinstall setuptools

RUN apt-get install --no-install-recommends rsync freeglut3-dev -y && rm -rf /var/lib/apt/lists/*;

ARG QT=5.9.9
ARG QT_HOST=linux
ARG QT_TARGET=desktop
RUN aqt install --outputdir /opt/qt ${QT} ${QT_HOST} ${QT_TARGET} -m all \
    && rsync -qabuP /opt/qt/${QT}/gcc_64/ /usr/local/

ENV PATH=/opt/conda/bin:/hbb_shlib/bin:/hbb/bin:/opt/rh/devtoolset-9/root/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV LDFLAGS=-L/opt/conda/lib

# Get and decompress linuxdeployqt, it's complicated to use fuse with docker due to the kernel module
RUN curl -f -L -o $HOME/linuxdeployqt.AppImage https://github.com/probonopd/linuxdeployqt/releases/download/5/linuxdeployqt-5-x86_64.AppImage && chmod +x $HOME/linuxdeployqt.AppImage; cd $HOME ; ./linuxdeployqt.AppImage --appimage-extract
RUN cp /root/squashfs-root/usr/bin/linuxdeployqt /usr/bin

RUN add-apt-repository ppa:git-core/ppa
RUN apt-get update
RUN apt-get upgrade git -y
RUN git --version
RUN apt-get install --no-install-recommends zip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libegl1-mesa libcups2 pigz wget ccache && rm -rf /var/lib/apt/lists/*;
RUN mkdir /root/.ccache && echo "compression = true" > /root/.ccache/ccache.conf
