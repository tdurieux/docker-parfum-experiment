# Dockerfile template
FROM <<base_image>>

RUN apt-get update && \
    apt-get install --no-install-recommends -y make build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget tar xz-utils bzip2 libcurl4-openssl-dev \
    curl sed grep zlib1g-dev libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/bin
      COPY tools/dockerfiles/build_scripts /build_scripts
      RUN bash /build_scripts/install_gcc.sh gcc82 && rm -rf /build_scripts
      RUN cp gcc gcc.bak && cp g++ g++.bak && rm gcc && rm g++
      RUN ln -s /usr/local/gcc-8.2/bin/gcc /usr/local/bin/gcc
      RUN ln -s /usr/local/gcc-8.2/bin/g++ /usr/local/bin/g++
      RUN ln -s /usr/local/gcc-8.2/bin/gcc /usr/bin/gcc
      RUN ln -s /usr/local/gcc-8.2/bin/g++ /usr/bin/g++
      ENV PATH=/usr/local/gcc-8.2/bin:$PATH

# install python
WORKDIR /home
      COPY tools/dockerfiles/build_scripts /build_scripts
      RUN bash /build_scripts/install_python.sh <<python_version>> && rm -rf /build_scripts
      # Other 

# install whl and bin
WORKDIR /home
      COPY tools/dockerfiles/build_scripts /build_scripts
      RUN bash /build_scripts/install_whl.sh <<serving_version>> <<paddle_version>> <<run_env>> <<python_version>> && rm -rf /build_scripts

WORKDIR /home
      COPY tools/dockerfiles/build_scripts /build_scripts
      RUN bash /build_scripts/soft_link.sh <<run_env>>

# install tensorrt
WORKDIR /home
      COPY tools/dockerfiles/build_scripts /build_scripts
      RUN bash /build_scripts/install_trt.sh <<run_env>> && rm -rf /build_scripts

# install go
RUN wget -qO- https://paddle-ci.cdn.bcebos.com/go1.17.2.linux-amd64.tar.gz | \
    tar -xz -C /usr/local && \
    mkdir /root/go && \
    mkdir /root/go/bin && \
    mkdir /root/go/src && \
    echo "GOROOT=/usr/local/go" >> /root/.bashrc && \
    echo "GOPATH=/root/go" >> /root/.bashrc && \
    echo "PATH=/usr/local/go/bin:/root/go/bin:$PATH" >> /root/.bashrc

RUN wget https://paddle-serving.bj.bcebos.com/others/centos_ssl.tar && \
    tar xf centos_ssl.tar && rm -rf centos_ssl.tar && \
    mv libcrypto.so.1.0.2k /usr/lib/libcrypto.so.1.0.2k && mv libssl.so.1.0.2k /usr/lib/libssl.so.1.0.2k && \
    ln -sf /usr/lib/libcrypto.so.1.0.2k /usr/lib/libcrypto.so.10 && \
    ln -sf /usr/lib/libssl.so.1.0.2k /usr/lib/libssl.so.10 && \
    ln -sf /usr/lib/libcrypto.so.10 /usr/lib/libcrypto.so && \
    ln -sf /usr/lib/libssl.so.10 /usr/lib/libssl.so

EXPOSE 22
