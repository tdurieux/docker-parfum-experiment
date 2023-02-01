ARG image=ubuntu:bionic

FROM ${image} as source-internet

FROM source-internet as builder

RUN apt-get update --quiet && apt-get install -y --no-install-recommends --quiet --assume-yes \
      git \
      build-essential \
      qt5-default \
      qtbase5-dev \
      qtscript5-dev \
      qttools5-dev-tools && rm -rf /var/lib/apt/lists/*;

RUN git clone --recursive https://github.com/horsicq/XELFViewer.git

RUN cd XELFViewer &&  bash -x build_dpkg.sh && bash -x install.sh