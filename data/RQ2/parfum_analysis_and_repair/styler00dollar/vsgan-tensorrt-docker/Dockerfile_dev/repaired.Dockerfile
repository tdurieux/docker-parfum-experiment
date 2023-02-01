# This is a cuda+vulkan docker
# This docker requires you to download some files yourself and place them into the current directory

# DOCKER_BUILDKIT=1 docker build -t styler00dollar/vsgan_tensorrt_dev:latest .

# 20.04 has python3.8, which is currently maximum for TensorRT 8.4 EA, 22.04 has 3.10

# installing vulkan
#https://github.com/bitnimble/docker-vulkan/blob/master/docker/Dockerfile.ubuntu20.04
#https://gitlab.com/nvidia/container-images/vulkan/-/blob/ubuntu16.04/Dockerfile
FROM ubuntu:20.04 as vulkan-khronos

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    git \
    libegl1-mesa-dev \
    libwayland-dev \
    libx11-xcb-dev \
    libxkbcommon-dev \
    libxrandr-dev \
    python3 \
    python3-distutils \
    wget && \
    rm -rf /var/lib/apt/lists/*

ARG VULKAN_VERSION=sdk-1.3.211
# Download and compile vulkan components
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    git clone https://github.com/KhronosGroup/Vulkan-ValidationLayers.git /opt/vulkan && \
    cd /opt/vulkan && git checkout "${VULKAN_VERSION}" && \
    mkdir build && cd build && ../scripts/update_deps.py && \
    cmake -C helper.cmake -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build . && make install && ldconfig && \
    mkdir -p /usr/local/include/vulkan && cp -r Vulkan-Headers/build/install/include/vulkan/* /usr/local/include/vulkan && \
    cp -r Vulkan-Headers/include/* /usr/local/include/vulkan && \
    mkdir -p /usr/local/share/vulkan/registry && \
    cp -r Vulkan-Headers/build/install/share/vulkan/registry/* /usr/local/share/vulkan/registry && \
    git clone https://github.com/KhronosGroup/Vulkan-Loader /opt/vulkan-loader && \
    cd /opt/vulkan-loader && git checkout "${VULKAN_VERSION}" && \
    mkdir build && cd build && ../scripts/update_deps.py && \
    cmake -C helper.cmake -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build . && make install && ldconfig && \
    mkdir -p /usr/local/lib && cp -a loader/*.so* /usr/local/lib && \
    rm -rf /opt/vulkan && rm -rf /opt/vulkan-loader


#FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04
FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04

ENV NVIDIA_DRIVER_CAPABILITIES all

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libx11-xcb-dev \
    libxkbcommon-dev \
    libwayland-dev \
    libxrandr-dev \
    libegl1-mesa-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=vulkan-khronos /usr/local/bin /usr/local/bin
COPY --from=vulkan-khronos /usr/local/lib /usr/local/lib
COPY --from=vulkan-khronos /usr/local/include/vulkan /usr/local/include/vulkan
COPY --from=vulkan-khronos /usr/local/share/vulkan /usr/local/share/vulkan

COPY nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json

######################

ARG DEBIAN_FRONTEND=noninteractive
# if you have 404 problems when you build the docker, try to run the upgrade
#RUN apt-get dist-upgrade -y

WORKDIR workspace

# wget
RUN apt-get -y update && apt install --no-install-recommends wget python3 python3.8 python3.8-venv python3.8-dev python3-pip python-is-python3 -y && \
    apt-get autoclean -y && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip

# download it from nvidias website and put it into the same folder
COPY nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb
ENV os1="ubuntu2004"
ENV tag="cuda11.6-trt8.4.1.5-ga-20220604"
ENV version="8.4.1-1+cuda11.6"
ENV trt_version="8.4.1.5-1+cuda11.6"
RUN dpkg -i nv-tensorrt-repo-${os1}-${tag}_1-1_amd64.deb
RUN apt-key add /var/nv-tensorrt-repo-${os1}-${tag}/9a60d8bf.pub
RUN apt-get update -y

# check available apt versions
#RUN apt-cache madison tensorrt

# 22.04 does not have python-libnvinfer
RUN apt-get install --no-install-recommends libnvinfer8=${version} libnvonnxparsers8=${version} libnvparsers8=${version} libnvinfer-plugin8=${version} \
    libnvinfer-dev=${version} libnvonnxparsers-dev=${version} libnvparsers-dev=${version} libnvinfer-plugin-dev=${version} \
    python3-libnvinfer=${version} -y && \

    apt-mark hold libnvinfer8 libnvonnxparsers8 libnvparsers8 libnvinfer-plugin8 libnvinfer-dev libnvonnxparsers-dev libnvparsers-dev \
    libnvinfer-plugin-dev python3-libnvinfer && \

    apt-get install --no-install-recommends tensorrt=${trt_version} -y && apt-get install --no-install-recommends python3-libnvinfer-dev=${version} -y && \
    rm -rf nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb && apt-get autoclean -y && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*;
# download it from nvidias website
COPY tensorrt-8.4.1.5-cp38-none-linux_x86_64.whl tensorrt-8.4.1.5-cp38-none-linux_x86_64.whl
RUN pip install --no-cache-dir tensorrt-8.4.1.5-cp38-none-linux_x86_64.whl && rm -rf tensorrt-8.4.1.5-cp38-none-linux_x86_64.whl && pip cache purge

# cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.0-rc1/cmake-3.23.0-rc1-linux-x86_64.sh && \
    chmod +x cmake-3.23.0-rc1-linux-x86_64.sh && sh cmake-3.23.0-rc1-linux-x86_64.sh --skip-license && \
    cp /workspace/bin/cmake /usr/bin/cmake && cp /workspace/bin/cmake /usr/lib/x86_64-linux-gnu/cmake && \
    cp /workspace/bin/cmake /usr/local/bin/cmake && cp -r /workspace/share/cmake-3.23 /usr/local/share/

# installing vapoursynth and torch
# for newer ubuntu: python-is-python3 libffms2-5
# currently not on 3.10: onnx onnxruntime onnxruntime-gpu
# python dependencies: python3 python3.8 python3.8-venv python3.8-dev

RUN apt update -y && \
    #apt install software-properties-common -y && add-apt-repository ppa:deadsnakes/ppa -y && \
    apt install --no-install-recommends pkg-config wget python3-pip git p7zip-full x264 ffmpeg autoconf libtool yasm ffmsindex libffms2-4 libffms2-dev -y && \
    git clone https://github.com/sekrit-twc/zimg.git && cd zimg && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j4 && make install && cd .. && rm -rf zimg && \
    pip install --no-cache-dir Cython && wget https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R59.zip && \
    7z x R59.zip && cd vapoursynth-R59 && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && cd .. && ldconfig && \
    ln -s /usr/local/lib/python3.8/site-packages/vapoursynth.so /usr/lib/python3.8/lib-dynload/vapoursynth.so && \
    pip install --no-cache-dir cmake scipy mmedit vapoursynth meson ninja numba numpy scenedetect kornia opencv-python cupy-cuda115 pytorch-msssim \
        https://download.pytorch.org/whl/cu115/torch-1.11.0%2Bcu115-cp38-cp38-linux_x86_64.whl \
        https://download.pytorch.org/whl/cpu/torchvision-0.12.0%2Bcpu-cp38-cp38-linux_x86_64.whl \
        https://github.com/pytorch/TensorRT/releases/download/v1.1.0/torch_tensorrt-1.1.0-cp38-cp38-linux_x86_64.whl \
        mmcv-full==1.5.0 -f https://download.openmmlab.com/mmcv/dist/cu115/torch1.11.0/index.html \
        onnx onnxruntime onnxruntime-gpu && \
    # not deleting vapoursynth-R59 since vs-mlrt needs it
    rm -rf R59.zip zimg && \
    apt-get autoclean -y && apt-get autoremove -y && apt-get clean -y && pip cache purge && rm -rf /var/lib/apt/lists/*;

# color transfer
RUN pip install --no-cache-dir docutils && git clone https://github.com/hahnec/color-matcher && cd color-matcher && python setup.py install && \
    cd /workspace && rm -rf color-matcher && pip cache purge

# imagemagick for imread
RUN apt-get install --no-install-recommends checkinstall libwebp-dev libopenjp2-7-dev librsvg2-dev libde265-dev -y && git clone https://github.com/ImageMagick/ImageMagick && cd ImageMagick && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared --with-modules --with-gslib && make && \
    make install && ldconfig /usr/local/lib && cd /workspace && rm -rf ImageMagick && \
    apt-get autoclean -y && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*;

# upgrading ffmpeg manually (ffmpeg 20220526 from https://johnvansickle.com/ffmpeg/)
RUN wget https://files.catbox.moe/cplts2 -O ffmpeg && \
    chmod +x ./ffmpeg && mv ffmpeg /usr/bin/ffmpeg

# installing tensorflow because of FILM
RUN pip install --no-cache-dir tensorflow tensorflow-gpu tensorflow_addons gin-config -U && pip3 cache purge

# installing onnx tensorrt with a workaround, error with import otherwise
# https://github.com/onnx/onnx-tensorrt/issues/643
RUN git clone https://github.com/onnx/onnx-tensorrt.git && \
    cd onnx-tensorrt && \
    cp -r onnx_tensorrt /usr/local/lib/python3.8/dist-packages && \
    cd .. && rm -rf onnx-tensorrt

# downloading models
RUN wget https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/RealESRGANv2-animevideo-xsx2.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/RealESRGANv2-animevideo-xsx4.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/RealESRGAN_x4plus_anime_6B.pth \
# fatal anime
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/4x_fatal_Anime_500000_G.pth \
# rvp1
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/rvpV1_105661_G.pt \
# sepconv
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/sepconv.pth \
# EGVSR
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/EGVSR_iter420000.pth \
# rife4 (fixed)
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/rife40.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/rife41.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/sudo_rife4_269.662_testV1_scale1.pth \
# RealBasicVSR_x4
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/RealBasicVSR_x4.pth \
# cugan models
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_up2x-latest-conservative.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_up2x-latest-denoise1x.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_up2x-latest-denoise2x.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_up2x-latest-denoise3x.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_up2x-latest-no-denoise.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_up3x-latest-conservative.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_up3x-latest-denoise3x.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_up3x-latest-no-denoise.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_up4x-latest-conservative.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_up4x-latest-denoise3x.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_up4x-latest-no-denoise.pth \

    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_pro-conservative-up2x.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_pro-conservative-up3x.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_pro-denoise3x-up2x.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_pro-denoise3x-up3x.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_pro-no-denoise3x-up2x.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/cugan_pro-no-denoise3x-up3x.pth \
# IFRNet
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/IFRNet_S_Vimeo90K.pth \
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/IFRNet_L_Vimeo90K.pth \
# film
    https://github.com/styler00dollar/VSGAN-tensorrt-docker/releases/download/models/FILM.tar.gz && \
    tar -zxvf FILM.tar.gz && rm -rf FILM.tar.gz
# RealBasicVSR_x4 will download this
RUN wget "https://download.pytorch.org/models/vgg19-dcbb9e9d.pth" -P /root/.cache/torch/hub/checkpoints/

# vs plugings from others
# https://github.com/HolyWu/vs-swinir
# https://github.com/HolyWu/vs-basicvsrpp
RUN pip install --no-cache-dir --upgrade vsswinir && python -m vsswinir && \
    pip install --no-cache-dir --upgrade vsbasicvsrpp && python -m vsbasicvsrpp && pip cache purge

# vs-mlrt
# upgrading g++
RUN apt install --no-install-recommends build-essential manpages-dev software-properties-common -y && add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt update -y && apt install --no-install-recommends gcc-11 g++-11 -y && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11 && \
# compiling
    git clone https://github.com/AmusementClub/vs-mlrt /workspace/vs-mlrt && cd /workspace/vs-mlrt/vstrt && mkdir build && \
    cd build && cmake .. -DVAPOURSYNTH_INCLUDE_DIRECTORY=/workspace/vapoursynth-R59/include && make && make install && \
    cd .. && rm -rf vs-mlrt && rm -rf /var/lib/apt/lists/*;

# x265
RUN git clone https://github.com/AmusementClub/x265 /workspace/x265 && cd /workspace/x265/source/ && mkdir build && cd build && \
    cmake .. -DNATIVE_BUILD=ON -DSTATIC_LINK_CRT=ON -DENABLE_AVISYNTH=OFF && make && make install && \
    cp /workspace/x265/source/build/x265 /usr/bin/x265 && \
    cp /workspace/x265/source/build/x265 /usr/local/bin/x265 && \
    cd .. && rm -rf x265

# descale
RUN git clone https://github.com/Irrational-Encoding-Wizardry/descale && cd descale && meson build && ninja -C build && ninja -C build install && \
    cd .. && rm -rf descale

# mpv
RUN apt install --no-install-recommends mpv -y && apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --yes pulseaudio-utils && \
    apt-get install --no-install-recommends -y pulseaudio && apt-get install --no-install-recommends pulseaudio libpulse-dev osspd -y && \
    apt-get autoclean -y && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*;

# av1an
RUN apt install --no-install-recommends curl -y && curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    . $HOME/.cargo/env && \
    apt install --no-install-recommends clang-12 nasm libavutil-dev libavformat-dev libavfilter-dev -y && \
    git clone https://github.com/master-of-zen/Av1an && \
    cd Av1an && cargo build --release --features ffmpeg_static && \
    mv /workspace/Av1an/target/release/av1an /usr/bin && \
    cd /workspace && rm -rf Av1an && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*;
# svt
RUN git clone https://github.com/AOMediaCodec/SVT-AV1 && cd SVT-AV1/Build/linux/ && sh build.sh release && \
    cd /workspace/SVT-AV1/Bin/Release/ && chmod +x ./SvtAv1EncApp && mv SvtAv1EncApp /usr/bin && \
    mv libSvtAv1Enc.so.1.1.0 /usr/local/lib && mv libSvtAv1Enc.so.1 /usr/local/lib && mv libSvtAv1Enc.so /usr/local/lib && \
    cd /workspace && rm -rf SVT-AV1

# pycuda and numpy hotfix (pycuda needs cuda which isnt in the current container, skipping)
RUN pip install --no-cache-dir pycuda numpy==1.21 --force-reinstall && pip cache purge

########################
# vulkan
RUN apt install --no-install-recommends vulkan-utils libvulkan1 libvulkan-dev -y && apt-get autoclean -y && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*;

RUN wget https://sdk.lunarg.com/sdk/download/1.3.211.0/linux/vulkansdk-linux-x86_64-1.3.211.0.tar.gz && tar -zxvf vulkansdk-linux-x86_64-1.3.211.0.tar.gz && \
    rm -rf vulkansdk-linux-x86_64-1.3.211.0.tar.gz
ENV VULKAN_SDK=/workspace/1.3.211.0/x86_64/

# rife ncnn
RUN wget https://github.com/Netflix/vmaf/archive/refs/tags/v2.3.1.tar.gz && \
    # VMAF
    tar -xzf  v2.3.1.tar.gz && cd vmaf-2.3.1/libvmaf/ && \
    meson build --buildtype release && ninja -C build && \
    ninja -C build install && cd /workspace && rm -rf v2.3.1.tar.gz vmaf-2.3.1 && \

    git clone https://github.com/HomeOfVapourSynthEvolution/VapourSynth-VMAF && cd VapourSynth-VMAF && meson build && \
    ninja -C build && ninja -C build install && cd /workspace && rm -rf VapourSynth-VMAF && \

    # MISC
    git clone https://github.com/vapoursynth/vs-miscfilters-obsolete && cd vs-miscfilters-obsolete && meson build && \
    ninja -C build && ninja -C build install && cd /workspace && rm -rf vs-miscfilters-obsolete && \
    
    # RIFE
    git clone https://github.com/styler00dollar/VapourSynth-RIFE-ncnn-Vulkan && cd VapourSynth-RIFE-ncnn-Vulkan && \
    git submodule update --init --recursive --depth 1 && meson build -Dbuildtype=debug -Db_lto=false && ninja -C build && ninja -C build install && \
    cd /workspace && rm -rf VapourSynth-RIFE-ncnn-Vulkan

# waifu ncnn
RUN git clone https://github.com/Nlzy/vapoursynth-waifu2x-ncnn-vulkan.git && cd vapoursynth-waifu2x-ncnn-vulkan && \
    git submodule update --init --recursive && mkdir build && cd build && cmake .. -DVAPOURSYNTH_HEADER_DIR=/workspace/vapoursynth-R59/include/ && \
    cmake --build . -j16 && make install && cd /workspace && rm -rf vapoursynth-waifu2x-ncnn-vulkan

# deleting files
RUN rm -rf 1.3.211.0 cmake-3.23.0-rc1-linux-x86_64.sh zimg vapoursynth-R59

# move trtexec so it can be globally accessed
RUN mv /usr/src/tensorrt/bin/trtexec /usr/bin