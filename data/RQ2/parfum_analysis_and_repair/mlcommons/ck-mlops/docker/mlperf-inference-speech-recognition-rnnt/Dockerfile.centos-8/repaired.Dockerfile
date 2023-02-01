FROM centos:8

# News:
#  * 20210525: Grigori updated this container to support the latest CK framework
#              with the latest CK components from ctuning@ai repo
LABEL maintainer="Grigori Fursin <grigori@octoml.ai>"

# Use the Bash shell.
SHELL ["/bin/bash", "-c"]

# Allow stepping into the Bash shell interactively.
ENTRYPOINT ["/bin/bash", "-c"]

# Install known system dependencies and immediately clean up to make the image smaller.
# CK needs: git, wget, zip, unzip.
# Python 3 needs: open-ssl-devel, bzip2-devel, libffi-devel.
# Speech Recognition program needs: sndfile-devel.
RUN yum upgrade -y\
 && yum install -y\
 gcc gcc-c++\
 make which patch vim\
 git wget zip unzip\
 openssl-devel bzip2-devel libffi-devel\
 dnf-plugins-core \
 && yum clean all && rm -rf /var/cache/yum
# NB: dnf is "the new yum".
RUN yum config-manager --set-enabled powertools
RUN dnf install -y python3 python3-pip python3-devel
RUN dnf --enablerepo=powertools install -y libsndfile-devel

# Create non-root user.
RUN useradd --create-home --user-group --shell /bin/bash dvdt
USER dvdt:dvdt
WORKDIR /home/dvdt

# Install Collective Knowledge (CK).
ENV CK_REPOS=/home/dvdt/CK_REPOS \
    CK_TOOLS=/home/dvdt/CK_TOOLS \
    PATH=${CK_ROOT}/bin:/home/dvdt/.local/bin:${PATH} \
    CK_PYTHON=python3.6 \
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

#-----------------------------------------------------------------------------#
# Step 1. Install C++ dependencies (FLAC, SoX).
#-----------------------------------------------------------------------------#
# Detect C/C++ compiler (gcc).
RUN ck detect soft:compiler.gcc --full_path=`which ${CK_CC}`
# Install preprocessing dependencies (FLAC, SoX).
RUN ck install package --tags=tool,flac
RUN ck install package --tags=tool,sox
#-----------------------------------------------------------------------------#


#-----------------------------------------------------------------------------#
# Step 2. Install Python dependencies (pip, Torch, SoX, pandas, Abseil, wheel).
#-----------------------------------------------------------------------------#
# Detect Python interpreter ("compiler").
RUN ck detect soft:compiler.python --full_path=`which ${CK_PYTHON}`
# Install PyTorch.
RUN ck install package --tags=python-package,torch --force_version=1.6.0
# Install preprocessing dependencies (SoX, pandas).
RUN ck install package --tags=python-package,sox
RUN ck install package --tags=python-package,pandas
# Install LoadGen dependencies (Abseil, wheel).
RUN ck install package --tags=python-package,absl
# Install other program dependencies.
# NB: Fix numba version: https://github.com/librosa/librosa/issues/1160
RUN ${CK_PYTHON} -m pip install --user tqdm toml unidecode inflect sndfile librosa numba==0.48
RUN ck install package --tags=lib,python-package,numpy
#-----------------------------------------------------------------------------#


#-----------------------------------------------------------------------------#
# Step 3. Download the official MLPerf Inference RNNT dataset (LibriSpeech
# dev-clean) and preprocess it to wav.
#-----------------------------------------------------------------------------#
RUN ck install package --tags=dataset,speech-recognition,dev-clean,original
# NB: Can ignore the lzma related warning.
RUN ck install package --tags=dataset,speech-recognition,dev-clean,preprocessed
#-----------------------------------------------------------------------------#


#-----------------------------------------------------------------------------#
# Step 4. Download the official MLPerf Inference RNNT model.
#-----------------------------------------------------------------------------#
RUN ck install package --tags=model,pytorch,rnnt
#-----------------------------------------------------------------------------#


#-----------------------------------------------------------------------------#
# Step 5. Download the MLPerf Inference repo with dividiti's RNNT tweaks,
# and build the Python LoadGen API.
#-----------------------------------------------------------------------------#
RUN ck install package --tags=mlperf,inference,source,dividiti.rnnt
RUN ck install package --tags=python-package,loadgen
#-----------------------------------------------------------------------------#


#-----------------------------------------------------------------------------#
# Run the Speech Recognition RNNT program in the accuracy mode.
#-----------------------------------------------------------------------------#
CMD ["ck run program:speech-recognition-pytorch-loadgen --cmd_key=accuracy --skip_print_timers"]
