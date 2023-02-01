ARG STARTING_IMAGE=nvidia/cuda:11.2.0-runtime-ubuntu20.04
FROM ${STARTING_IMAGE}

# Set frontend as non-interactive
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# Install python and pip
RUN apt-get install --no-install-recommends -y python3-opencv python3-pip && \
    python3 -m pip install --upgrade pip && \
    apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

# Install nebullvm
ARG NEBULLVM_VERSION=latest
RUN if [ "$NEBULLVM_VERSION" = "latest" ] ; then \
        git clone https://github.com/nebuly-ai/nebullvm.git ; \
        cd nebullvm ; \
        pip install --no-cache-dir .; \
    else \
        pip install --no-cache-dir nebullvm==${NEBULLVM_VERSION}; \
    fi

# Install required python modules
RUN pip install --no-cache-dir scipy==1.5.4 && \
    pip install --no-cache-dir cmake

# Install default deep learning compilers
ARG COMPILER=all
ENV NO_COMPILER_INSTALLATION=1
RUN if [ "$COMPILER" = "all" ] ; then \
        python3 -c "import os; os.environ['NO_COMPILER_INSTALLATION'] = '0'; import nebullvm" ; \
    elif [ "$COMPILER" = "tensorrt" ] ; then \
        python3 -c "from nebullvm.installers.installers import install_tensor_rt; install_tensor_rt()" ; \
    elif [ "$COMPILER" = "openvino" ] ; then \
        python3 -c "from nebullvm.installers.installers import install_openvino; install_openvino()" ; \
    elif [ "$COMPILER" = "onnxruntime" ] ; then \
        python3 -c "from nebullvm.installers.installers import install_onnxruntime; install_onnxruntime()" ; \
    fi

# Install TVM
RUN if [ "$COMPILER" = "all" ] || [ "$COMPILER" = "tvm" ] ; then \
        python3 -c "from nebullvm.installers.installers import install_tvm; install_tvm()" ; \
        python3 -c "from tvm.runtime import Module" ; \
    fi
