FROM --platform=linux/amd64 ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive
ARG PYTHON_VERSION=3.10.1
RUN apt update -y
RUN apt upgrade -y
RUN apt install --no-install-recommends libssl1.1 -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends pylint3 -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends less -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends emacs-nox -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends xz-utils -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends build-essential checkinstall -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends libreadline-gplv2-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends libncursesw5-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends libssl-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends openssl -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends libsqlite3-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends tk-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends libgdbm-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends libc6-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends libbz2-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends libffi-dev -y && rm -rf /var/lib/apt/lists/*;
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz
RUN tar xf Python-${PYTHON_VERSION}.tar.xz && rm Python-${PYTHON_VERSION}.tar.xz
RUN cd Python-${PYTHON_VERSION} && \
 ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
 --enable-optimizations \
 --prefix=/usr/local \
 --enable-shared\
 LDFLAGS="-Wl,-rpath /usr/local/lib" && \
 make -j4 build_all && \
 make altinstall
RUN rm Python-${PYTHON_VERSION}.tar.xz
RUN rm /usr/bin/python3 && ln -s /usr/local/bin/python3.10 /usr/bin/python3
RUN ln -s /usr/local/bin/pip3.10 /usr/bin/pip3
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir pyinstaller
RUN pip3 install --no-cache-dir pylint