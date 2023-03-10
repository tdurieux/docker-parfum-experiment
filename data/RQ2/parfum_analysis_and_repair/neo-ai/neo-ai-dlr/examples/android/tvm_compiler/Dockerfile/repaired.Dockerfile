FROM ubuntu:19.10

RUN apt update

RUN apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y llvm-9 clang-9 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y cmake git wget curl vim zip && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3 python3-dev python3-distutils && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libedit-dev libxml2-dev antlr4 && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py && python3 get-pip.py && rm get-pip.py

RUN pip3 install --no-cache-dir -U pip setuptools wheel
RUN pip3 install --no-cache-dir numpy decorator attrs antlr4-python3-runtime

WORKDIR /root
RUN git clone --recursive https://github.com/dmlc/tvm
WORKDIR /root/tvm/build
RUN cmake -DUSE_LLVM=ON -DUSE_ANTLR=ON .. && make -j$(nproc)

WORKDIR /root/tvm/python
RUN python3 setup.py install
WORKDIR /root/tvm/topi/python
RUN python3 setup.py install

WORKDIR /root
RUN pip3 install --no-cache-dir tensorflow==1.15 keras keras-applications
RUN pip3 install --no-cache-dir mxnet gluoncv

WORKDIR /opt
RUN wget https://dl.google.com/android/repository/android-ndk-r20b-linux-x86_64.zip
RUN unzip android-ndk-r20b-linux-x86_64.zip && rm android-ndk-r20b-linux-x86_64.zip
RUN ln -s android-ndk-r20b android-ndk

WORKDIR /root/tvm_compiler
COPY tvm_compiler_utils.py compile_keras.py compile_tensorflow.py compile_gluoncv.py ./
