FROM gemfield/cuda:11.0.3-cudnn8-devel-ubuntu20.04
LABEL maintainer "Gemfield <gemfield@civilnet.cn>"

WORKDIR /gemfield
RUN curl -f -L https://github.com/CivilNet/libtorch/releases/download/1.8.0/libtorch.tar.gz -o libtorch.tar.gz && \
    tar zxvf libtorch.tar.gz && \
    rm libtorch.tar.gz

RUN conda install -y pytorch -c gemfield && \
    conda clean -ya && \
    /opt/conda/bin/conda clean -y --force-pkgs-dirs

RUN git clone https://github.com/DeepVAC/libdeepvac libdeepvac && \
    cd libdeepvac && \
    mkdir build && \
    mkdir install && \
    cd build && \
    cmake -DBUILD_STATIC=ON -DUSE_STATIC_LIBTORCH=ON -DUSE_MKL=ON -DUSE_CUDA=ON -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_PREFIX_PATH="/gemfield/libtorch;/gemfield/opencv4deepvac/" -DCMAKE_INSTALL_PREFIX=../install .. && \
    cmake --build . --config Release && \
    make install && \
    cd .. && \
    rm -rf build

RUN pip3 install --no-cache-dir --upgrade deepvac
