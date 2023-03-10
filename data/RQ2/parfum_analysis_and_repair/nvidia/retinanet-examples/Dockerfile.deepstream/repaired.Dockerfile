FROM nvcr.io/nvidia/pytorch:20.03-py3
COPY . /workspace/retinanet-examples/
RUN apt-get update && apt-get install --no-install-recommends -y libssl1.0.0 libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstrtspserver-1.0-0 libjansson4 ffmpeg libjson-glib-1.0 libgles2-mesa && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/edenhill/librdkafka.git /librdkafka && \
    cd /librdkafka && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j && make -j install && \
    mkdir -p /opt/nvidia/deepstream/deepstream-4.0/lib && \
    cp /usr/local/lib/librdkafka* /opt/nvidia/deepstream/deepstream-4.0/lib && \
    rm -rf /librdkafka
WORKDIR /workspace/retinanet-examples/extras/deepstream/DeepStream_Release/deepstream_sdk_v4.0.2_x86_64
RUN tar -xvf binaries.tbz2 -C / && \
    ./install.sh
# config files + sample apps
RUN chmod u+x ./sources/tools/nvds_logger/setup_nvds_logger.sh

WORKDIR /usr/lib/x86_64-linux-gnu
RUN ln -sf libnvcuvid.so.1 libnvcuvid.so

WORKDIR /workspace/retinanet-examples
RUN pip install --no-cache-dir -e .
RUN mkdir extras/deepstream/deepstream-sample/build && \
    cd extras/deepstream/deepstream-sample/build && \
    cmake -DDeepStream_DIR=/workspace/retinanet-examples/extras/deepstream/DeepStream_Release/deepstream_sdk_v4.0.2_x86_64 .. && make -j
WORKDIR /workspace/retinanet-examples/extras/deepstream
