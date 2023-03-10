FROM ubuntu:artful

ENV LANG=C.UTF-8

RUN apt update && apt install -y --no-install-recommends software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository ppa:openjdk-r/ppa && \
    apt install -y --no-install-recommends build-essential swig dos2unix openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

RUN apt install python3-dev python3-pip -y --no-install-recommends && pip3 install --no-cache-dir --upgrade pip setuptools && pip3 install --no-cache-dir --upgrade cffi && rm -rf /var/lib/apt/lists/*;

# common packages
RUN apt install --no-install-recommends -y \
    ca-certificates curl file \
    build-essential \
    autoconf automake autotools-dev libtool xutils-dev openssl libssl1.0.0 && rm -rf /var/lib/apt/lists/*;

RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain stable -y

RUN sh -c ". ~/.cargo/env && python3 --version && rustc --version"

RUN apt install -y --no-install-recommends bzip2 wget && rm -rf /var/lib/apt/lists/*;

RUN wget https://bitbucket.org/squeaky/portable-pypy/downloads/pypy3.5-5.10.0-linux_x86_64-portable.tar.bz2 && tar -xvf pypy3.5-5.10.0-linux_x86_64-portable.tar.bz2 && rm pypy3.5-5.10.0-linux_x86_64-portable.tar.bz2

ENV PATH="/pypy3.5-5.10.0-linux_x86_64-portable/bin:${PATH}"
ENV LD_LIBRARY_PATH="/pypy3.5-5.10.0-linux_x86_64-portable/bin:${LD_LIBRARY_PATH}"
ENV INCLUDE="/pypy3.5-5.10.0-linux_x86_64-portable/include:${INCLUDE}"

RUN pypy3 -m ensurepip && pypy3 -m pip install --upgrade pip setuptools cffi
