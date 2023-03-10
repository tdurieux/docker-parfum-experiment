# Desc: Customized clipper base container for hysia with gpu support.
# Author: Zhou Shengsheng
# Date: 15-02-19
# Reference:
#   https://github.com/ucbrise/clipper/issues/338
#   https://github.com/cwtan501/nvidia_tf_template/blob/master/nvidia_docker_template#L34
#   https://github.com/ucbrise/clipper/blob/develop/dockerfiles/PyClosureContainerDockerfile
#   http://clipper.ai/tutorials/custom_model_container/

FROM nvidia/cuda:9.0-cudnn7-devel

# Install binary dependencies
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE 1
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https wget && apt-get purge -y nodejs npm && \
    wget https://deb.nodesource.com/setup_8.x -O setup_nodejs.sh && bash setup_nodejs.sh && rm setup_nodejs.sh && \
    apt-get install --no-install-recommends -y --allow-unauthenticated python3 python3-pip python3-tk vim \
      libzmq5 libzmq5-dev redis-server libsodium18 build-essential libglib2.0-0 libsm6 libxext6 tk libssl-dev \
      libswscale-dev libswresample-dev libva-drm1 libva-x11-1 libopenblas-dev libvpx-dev nodejs \
      libtheora0 libvorbis-dev libvdpau-dev libnuma-dev && \
    rm -rf /var/cache/apt/archives && \
    rm -rf /usr/bin/python && rm -rf /usr/bin/pip && \
    ln -s /usr/bin/python3 /usr/bin/python && ln -s /usr/bin/pip3 /usr/bin/pip && rm -rf /var/lib/apt/lists/*;

# Modify the environment variables
ENV PATH /usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64

# Install python dependencies
RUN pip install --upgrade --no-cache-dir pip==9.0.3
RUN pip install --upgrade --no-cache-dir setuptools certifi
RUN pip install --no-cache-dir cython==0.29 numpy==1.16.1
RUN pip install --no-cache-dir absl-py==0.6.1 addict==2.2.0 alabaster==0.7.12 astor==0.7.1 audioread==2.1.6 \
                babel==2.6.0 chardet==3.0.4 click==7.0 commonmark==0.5.4 cycler==0.10.0 dask==0.20.1 \
                decorator==4.3.0 django==2.0 django-crispy-forms==1.7.2 djangorestframework==3.8.2 \
                docutils==0.14 easydict==1.8 gast==0.2.0 googleapis-common-protos==1.5.3 \
                grpcio==1.15.0 grpcio-tools==1.15.0 idna==2.7 imageio==2.4.1 imagesize==1.1.0 \
                jinja2==2.10 joblib==0.13.0 kiwisolver==1.0.1 librosa==0.6.2 llvmlite==0.25.0 \
                markdown==3.0.1 markupsafe==1.1.0 matplotlib==2.2.2 mmcv==0.2.0 msgpack==0.5.6 \
                networkx==2.2 numba==0.40.1 opencv-python==3.4.3.18 packaging==18.0 pandas==0.23.4 \
                purepng==0.2.0 pydub==0.23.0 pygments==2.2.0 pyparsing==2.3.0 \
                python-dateutil==2.7.5 pytz==2018.7 pywavelets==1.0.1 pyyaml==3.13 recommonmark==0.4.0 \
                requests==2.20.1 resampy==0.2.1 rinoh-typeface-dejavuserif==0.1.1 \
                rinoh-typeface-texgyrecursor==0.1.1 rinoh-typeface-texgyreheros==0.1.1 \
                rinoh-typeface-texgyrepagella==0.1.1 rinohtype==0.3.1 scenedetect==0.5 \
                scikit-image==0.14.2 scikit-learn==0.20.0 scipy==1.1.0 seaborn==0.9.0 \
                snowballstemmer==1.2.1 sphinx==1.8.1 sphinxcontrib-websupport==1.1.0 tabulate==0.8.2 \
                termcolor==1.1.0 terminaltables==3.1.0 toolz==0.9.0 torchvision==0.2.1 \
                tqdm==4.28.1 urllib3==1.24.1 werkzeug==0.14.1 cython==0.29 cffi==1.11.5 ninja==1.8.2 \
                django-cors-headers==2.4.0 cloudpickle==0.5.3 torch==0.4.1 pycocotools==2.0.0 \
                pyzmq==17.0.0 prometheus==0.3.0 prometheus_client==0.5.0 clipper_admin==0.3.0 \
                pybind11==2.2.4 channels==2.1.7 soundfile==0.10.2
# RUN pip install --no-cache-dir faiss-gpu==1.4.0
RUN pip uninstall -y protobuf-py3 protobuf 2> /dev/null || true
RUN pip install --no-cache-dir tensorboard==1.9.0 tensorboardx==1.4 tensorflow-gpu==1.9.0 tensorflow-hub==0.1.1

# Copy the module from local filesystem into the Docker image
RUN mkdir -p /hysia-deps
COPY hysia /hysia-deps/hysia
COPY third /hysia-deps/third
COPY weights /hysia-deps/weights

# Build third libraries
RUN cd /hysia-deps/third && sh compile.sh

# Add the module to PYTHONPATH so the Python interpreter can find it
ENV PYTHONPATH="$PYTHONPATH:/hysia-deps/hysia:/hysia-deps/third"

# Setup clipper
COPY clipper/clipper_admin /clipper_admin/
# RUN cd /clipper_admin && pip install .
RUN mkdir -p /container/
WORKDIR /container
COPY clipper/containers/python/__init__.py clipper/containers/python/rpc.py \
     clipper/containers/python/python_closure_container.py clipper/containers/python/container_entry.sh \
     clipper/monitoring/metrics_config.yaml /container/
ENV CLIPPER_MODEL_PATH=/model
HEALTHCHECK --interval=3s --timeout=3s --retries=1 CMD test -f /model_is_ready.check || exit 1

ENTRYPOINT ["/container/container_entry.sh", "py-closure-container", "/container/python_closure_container.py"]
