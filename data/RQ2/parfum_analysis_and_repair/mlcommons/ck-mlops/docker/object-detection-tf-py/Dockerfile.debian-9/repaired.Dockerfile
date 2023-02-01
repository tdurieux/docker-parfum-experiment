FROM debian:9

# News:
#  * 20210525: Grigori updated this container to support the latest CK framework
#              with the latest CK components from ctuning@ck-ml repo
LABEL maintainer="Grigori Fursin <grigori@octoml.ai>"

# Use the Bash shell.
SHELL ["/bin/bash", "-c"]

# Allow stepping into the Bash shell interactively.
ENTRYPOINT ["/bin/bash", "-c"]

# Install known system dependencies and immediately clean up to make the image smaller.
# CK needs: git, wget, zip.
# TF needs: curl.
# TensorFlow Object Detection API needs ProtoBuf 3.0 which needs CMake.
RUN apt update -y \
 && apt install --no-install-recommends -y apt-utils \
 && apt upgrade -y \
 && apt install --no-install-recommends -y \
 git wget zip libz-dev \
 curl \
 cmake \
 python3 python3-pip \
 vim \
 && apt clean && rm -rf /var/lib/apt/lists/*;

# Create non-root user.
RUN useradd --create-home --user-group --shell /bin/bash dvdt
USER dvdt:dvdt
WORKDIR /home/dvdt

# Install Collective Knowledge (CK).
ENV CK_REPOS=/home/dvdt/CK_REPOS \
    CK_TOOLS=/home/dvdt/CK_TOOLS \
    PATH=/home/dvdt/.local/bin:${PATH} \
    CK_PYTHON=python3 \
    CK_CC=gcc \
    LANG=C.UTF-8

RUN mkdir -p ${CK_REPOS} ${CK_TOOLS}

# Install CK (CK automation f49f20744aba90e2)
# We need to install new pip and setuptools otherwise there is a conflict
# with the local CK installation of Python packages ...
RUN export DUMMY_CK=A
RUN ${CK_PYTHON} --version
RUN ${DUMMY_CK} ${CK_PYTHON} -m pip install --ignore-installed pip setuptools wheel --user
RUN ${DUMMY_CK} ${CK_PYTHON} -m pip install pyyaml virtualenv --user
RUN ${DUMMY_CK} ${CK_PYTHON} -m pip install ck --user

# Pull CK repositories
RUN ck pull repo:mlcommons@ck-mlops

# Use generic Linux settings with dummy frequency setting scripts.
RUN ck detect platform.os --platform_init_uoa=generic-linux-dummy

# Detect C/C++ compiler (gcc).
RUN ck detect soft:compiler.gcc --full_path=`which ${CK_CC}`

# Detect Python.
RUN ck detect soft:compiler.python --full_path=`which ${CK_PYTHON}`

# Install Python dependencies.
RUN ck install package --tags=lib,python-package,numpy
RUN ck install package --tags=lib,python-package,scipy --force_version=1.2.1
RUN ck install package --tags=lib,python-package,pillow
RUN ck install package --tags=lib,python-package,matplotlib
RUN ck install package --tags=lib,python-package,cython
RUN ck show env --tags=python-package

RUN ${CK_PYTHON} -m pip install gast --user
RUN ${CK_PYTHON} -m pip install astor --user
RUN ${CK_PYTHON} -m pip install termcolor --user
RUN ${CK_PYTHON} -m pip install tensorflow-estimator==1.13.0 --user
RUN ${CK_PYTHON} -m pip install keras_applications==1.0.4 --no-deps --user
RUN ${CK_PYTHON} -m pip install keras_preprocessing==1.0.2 --no-deps --user

# Install Python COCO API.
RUN ck install package --tags=tool,coco,api

# Install TF.
RUN ck install package:lib-tensorflow-1.13.1-cpu

# Download the COCO 2017 validation dataset (5,000 images) to the default path.
RUN echo | ck install package --tags=object-detection,dataset,coco.2017,val,original,full\
 && ck virtual env --tags=object-detection,dataset,coco.2017,val,original,full --shell_cmd=\
'rm $CK_ENV_DATASET_COCO_LABELS_DIR/*train2017.json'

# Download the SSD-MobileNet TF models (non-quantized and quantized).
RUN ck install package --tags=model,tf,object-detection,mlperf,ssd-mobilenet,non-quantized,from-zenodo
RUN ck install package --tags=model,tf,object-detection,mlperf,ssd-mobilenet,quantized,finetuned,from-zenodo

RUN ck install package --tags=lib,python-package,cv2,opencv-python-headless
RUN ck install package --tags=tensorflow,model,api,r1.13.0

# Run the Object Detection TF-Python program
# with the non-quantized SSD-MobileNet model
# on the first 50 images of the COCO 2017 validation dataset.
CMD ["ck run program:object-detection-tf-py --env.CK_BATCH_COUNT=50 --dep_add_tags.weights=ssd-mobilenet,non-quantized"]
