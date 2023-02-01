ARG image=ubuntu:bionic

FROM ${image} as source-internet

RUN apt-get update --quiet && \
    apt-get install -y --no-install-recommends --quiet --assume-yes git && rm -rf /var/lib/apt/lists/*;
RUN git clone --recursive https://github.com/horsicq/XPEViewer.git

FROM source-internet as builder

RUN apt-get update --quiet
RUN apt-get install -y --no-install-recommends --quiet --assume-yes \
      git \
      build-essential \
      qt5-default \
      qtbase5-dev \
      qttools5-dev-tools && rm -rf /var/lib/apt/lists/*;

RUN qtchooser -print-env \
 && qmake --version

RUN cd XPEViewer &&  bash -x build_dpkg.sh && bash -x install.sh