ARG IMAGE
FROM ${IMAGE}

SHELL ["/bin/bash", "-i", "-c"]

ARG PYTHON_VERSION=3.7.5

## Install System Dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        wget \
        git \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        zlib1g-dev \
        libffi-dev \
        libgdbm-dev \
        uuid-dev \
        upx \
        libusb-1.0-0-dev \
        gcc \
        g++ \
        swig \
        pkg-config \
        libpulse-dev \
        libxss1 \
        libsamplerate-dev \
        libasound2-dev \
        libxcb-xinerama0-dev \
        cmake && rm -rf /var/lib/apt/lists/*;

## Build System Dependencies
RUN wget https://www.zlib.net/fossils/zlib-1.2.9.tar.gz \
    && tar -xvf zlib-1.2.9.tar.gz \
    && cd zlib-1.2.9 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make -j$(nproc) install \
    && cd ./.. && rm zlib-1.2.9.tar.gz

## Install Pyenv
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && source ~/.bashrc \
    && curl -f -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
    && PYTHON_CONFIGURE_OPTS="--enable-shared" MAKE_OPTS="-j$(nproc)" pyenv install $PYTHON_VERSION \
    && source ~/.bashrc \
    && pyenv global $PYTHON_VERSION

RUN git clone https://github.com/Kitware/CMake.git \
    && cd CMake \
    && mkdir build && cd build \
    && cmake .. && make -j$(nproc) install \
    && ldconfig \
    && cd ./../..

## Install Additional System Dependencies
RUN pip install --no-cache-dir pip --upgrade
RUN pip install --no-cache-dir ninja

## Install SoapySDR
RUN git clone https://github.com/pothosware/SoapySDR.git \
    && cd SoapySDR \
    && mkdir build && cd build \
    && cmake -GNinja -Wno-dev -DPYTHON_INSTALL_DIR=/root/.pyenv/versions/3.7.5/lib/python3.7/site-packages .. && ninja install \
    && ldconfig \
    && cd ./../..

## Install RTL-SDR SDK
RUN git clone https://github.com/osmocom/rtl-sdr.git \
    && cd rtl-sdr \
    && mkdir build && cd build \
    && cmake -GNinja -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON .. && ninja install \
    && ldconfig \
    && cd ./../..

RUN git clone https://github.com/pothosware/SoapyRTLSDR.git \
    && cd SoapyRTLSDR \
    && mkdir build && cd build \
    && cmake -GNinja .. && ninja install \
    && ldconfig \
    && cd ./../..

## Install Airspy HF+ SDK
RUN git clone https://github.com/airspy/airspyhf.git \
    && cd airspyhf \
    && mkdir build && cd build \
    && cmake -GNinja .. && ninja install \
    && ldconfig \
    && cd ./../..

RUN git clone https://github.com/pothosware/SoapyAirspyHF.git \
    && cd SoapyAirspyHF \
    && mkdir build && cd build \
    && cmake -GNinja .. && ninja install \
    && ldconfig \
    && cd ./../..

## Install LimeSDR SDK
RUN git clone https://github.com/myriadrf/LimeSuite.git \
    && cd LimeSuite \
    && cd build \
    && cmake -GNinja .. && ninja install \
    && ldconfig \
    && cd ./../..

## Install Airspy One SDK
RUN git clone https://github.com/airspy/airspyone_host.git \
    && cd airspyone_host \
    && mkdir build && cd build \
    && cmake -GNinja .. && ninja install \
    && ldconfig \
    && cd ./../..

RUN git clone https://github.com/pothosware/SoapyAirspy.git \
    && cd SoapyAirspy \
    && mkdir build && cd build \
    && cmake -GNinja .. && ninja install \
    && ldconfig \
    && cd ./../..

## Install Latest PortAudio
RUN git clone https://git.assembla.com/portaudio.git \
    && cd portaudio \
    && wget https://lists.columbia.edu/pipermail/portaudio/attachments/20190726/10029c93/attachment.bin \
    && patch -p1 -ruN -d . < attachment.bin \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j$(nproc) install \
    && ldconfig \
    && cd ./../..

RUN if [ $(uname -m) == "aarch64" ]; \
    then \
    apt-get install -y --no-install-recommends qt5-default python3-pyqt5; rm -rf /var/lib/apt/lists/*; \
    fi

RUN if [ $(uname -m) == "aarch64" ]; \
    then \
    pip3 install --no-cache-dir -v pyqt5; \
    fi

RUN if [ $(uname -m) == "aarch64" ]; \
    then \
    apt-get install -y --no-install-recommends libblas3 liblapack3 liblapack-dev libblas-dev gfortran libatlas-base-dev; rm -rf /var/lib/apt/lists/*; \
    fi

RUN if [ $(uname -m) == "aarch64" ]; \
    then \
    pip3 install --no-cache-dir -v scipy; \
    fi

COPY ./requirements.txt .
RUN cat requirements.txt | xargs -n 1 -L 1 pip3 install

ADD . home
COPY ./docker/compiler/generator.sh generator.sh
ENTRYPOINT ["bash", "./generator.sh"]
