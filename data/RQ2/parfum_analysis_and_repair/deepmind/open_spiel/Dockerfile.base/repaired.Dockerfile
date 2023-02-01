FROM ubuntu:20.04 as base
RUN apt update
RUN dpkg --add-architecture i386 && apt update
RUN apt-get -y --no-install-recommends install \
    clang \
    curl \
    git \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    sudo && rm -rf /var/lib/apt/lists/*;
RUN mkdir repo
WORKDIR /repo

RUN sudo pip3 install --no-cache-dir --upgrade pip
RUN sudo pip3 install --no-cache-dir matplotlib

# install
COPY . .
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN ./install.sh
RUN pip3 install --no-cache-dir --upgrade setuptools testresources
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt
RUN pip3 install --no-cache-dir --upgrade cmake

# build and test
RUN mkdir -p build
WORKDIR /repo/build
RUN cmake -DPython3_EXECUTABLE=`which python3` -DCMAKE_CXX_COMPILER=`which clang++` ../open_spiel
RUN make -j12
ENV PYTHONPATH=${PYTHONPATH}:/repo
ENV PYTHONPATH=${PYTHONPATH}:/repo/build/python
RUN ctest -j12
WORKDIR /repo/open_spiel

# minimal image for development in Python
FROM python:3.6-slim-buster as python-slim
RUN mkdir repo
WORKDIR /repo
COPY --from=base /repo .
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt
RUN pip3 install --no-cache-dir matplotlib
ENV PYTHONPATH=${PYTHONPATH}:/repo
ENV PYTHONPATH=${PYTHONPATH}:/repo/build/python
WORKDIR /repo/open_spiel
