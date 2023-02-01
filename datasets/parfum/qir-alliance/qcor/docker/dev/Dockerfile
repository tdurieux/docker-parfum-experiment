FROM theiaide/theia-full:latest
USER root
RUN apt-get -y update && apt-get install -y libcurl4-openssl-dev libssl-dev \
              python3 libpython3-dev python3-pip gdb gfortran libblas-dev \
              liblapack-dev pkg-config software-properties-common \
    && python3 -m pip install cmake
RUN apt-get -y update \ 
    && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && add-apt-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" \
    && apt-get -y update && apt-get -y install libclang-9-dev llvm-9-dev clang-9 \
    && ln -s /usr/bin/llvm-config-9 /usr/bin/llvm-config 
ADD settings.json /home/.theia/

