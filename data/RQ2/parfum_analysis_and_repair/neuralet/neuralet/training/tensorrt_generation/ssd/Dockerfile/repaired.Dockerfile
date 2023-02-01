# docker can be installed on the dev board following these instructions:
# https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-repository , step 4: arm64
# 1) build: docker build -f Dockerfile -t "neuralet/jetson-nano:tf-ssd-to-trt" .
# 2) run: docker run -it --runtime nvidia --privileged --network host -v /PATH_TO_DOCKERFILE_DIRECTORY/:/repo neuralet/jetson-nano:tf-ssd-to-trt

FROM nvcr.io/nvidia/l4t-base:r32.3.1

ENV TZ=US/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

VOLUME /repo

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip pkg-config && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --upgrade pip

RUN apt-get install --no-install-recommends -y python3-numpy && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install pycuda

RUN apt-get install --no-install-recommends -y vim git && rm -rf /var/lib/apt/lists/*;
RUN printf 'deb https://repo.download.nvidia.com/jetson/common r32 main\ndeb https://repo.download.nvidia.com/jetson/t210 r32 main' > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list

COPY ./trusted-keys /tmp/trusted-keys
RUN apt-key add /tmp/trusted-keys
RUN apt-get update
RUN apt-get install --no-install-recommends -y tensorrt && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libnvinfer6 libnvinfer-dev python3-libnvinfer python3-libnvinfer-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y graphsurgeon-tf uff-converter-tf && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir protobuf
RUN apt-get install --no-install-recommends -y pkg-config libhdf5-100 libhdf5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-h5py && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v43 tensorflow==1.15.2+nv20.2
RUN pip3 install --no-cache-dir wget

COPY libflattenconcat.so.6 /repo
COPY graphsurgeon.patch-4.2.2 /repo
COPY install.sh /repo
RUN chmod +x /repo/install.sh && /repo/install.sh

WORKDIR /repo
ENTRYPOINT ["python3", "build_engine.py"]
CMD ["--config", "configs/config_ssd_mobilenet_v2_pedestrian.ini"]
