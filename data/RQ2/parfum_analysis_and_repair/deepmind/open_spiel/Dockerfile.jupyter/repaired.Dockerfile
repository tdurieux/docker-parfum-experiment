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
RUN cmake -DPython_TARGET_VERSION=${PYVERSION} -DCMAKE_CXX_COMPILER=`which clang++` ../open_spiel
RUN make -j12
ENV PYTHONPATH=${PYTHONPATH}:/repo
ENV PYTHONPATH=${PYTHONPATH}:/repo/build/python
# ctest can be disabled for faster builds when tests are not required
RUN ctest -j12
WORKDIR /repo/open_spiel

# Jupyterlab Environment
FROM base as jupyterlab
RUN pip install --no-cache-dir jupyter -U && pip install --no-cache-dir jupyterlab
EXPOSE 8888
ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root"]
