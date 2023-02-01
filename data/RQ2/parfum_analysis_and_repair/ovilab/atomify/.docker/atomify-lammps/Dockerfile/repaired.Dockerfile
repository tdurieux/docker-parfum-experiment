FROM ubuntu:16.04

RUN apt-get -qq update
RUN apt-get install -y --no-install-recommends -qq sudo && rm -rf /var/lib/apt/lists/*;

RUN sudo apt-get -qq update
RUN sudo apt-get -qq -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -qq -y --no-install-recommends install python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-add-repository -y ppa:beineri/opt-qt58-xenial
RUN sudo apt-get -qq update
RUN sudo apt-get -qq -y --no-install-recommends install qt583d qt58charts-no-lgpl qt58datavis3d-no-lgpl qt58declarative qt58svg && rm -rf /var/lib/apt/lists/*;

# install packages needed by configure
RUN sudo apt-get -qq -y --no-install-recommends install patch git build-essential curl && rm -rf /var/lib/apt/lists/*;

# needed by build
RUN sudo apt-get -qq -y --no-install-recommends install mesa-common-dev && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -qq -y --no-install-recommends install libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;

# needed by deploy
RUN sudo apt-get -qq -y --no-install-recommends install snapcraft && rm -rf /var/lib/apt/lists/*;
RUN sudo snap install core

WORKDIR /app

ADD . /app/
RUN ./configure.py
