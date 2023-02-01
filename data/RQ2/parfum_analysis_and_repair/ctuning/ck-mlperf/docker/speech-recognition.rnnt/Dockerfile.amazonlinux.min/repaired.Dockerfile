FROM amazonlinux:2

LABEL maintainer="Anton Lokhmotov <anton@dividiti.com>"

# Use the Bash shell.
SHELL ["/bin/bash", "-c"]

# Allow stepping into the Bash shell interactively.
ENTRYPOINT ["/bin/bash", "-c"]

# Install known system dependencies and immediately clean up to make the image smaller.
# CK needs: git, wget, zip, unzip.
# FLAC needs: tar, xz.
# Speech Recognition program needs: sndfile-devel.
RUN yum upgrade -y\
 && yum install -y\
 python3 python3-pip python3-devel\
 gcc gcc-c++\
 make which patch vim\
 git wget zip unzip\
 tar xz\
 libsndfile-devel \
 && yum clean all && rm -rf /var/cache/yum

# Create non-root user.
RUN useradd --create-home --user-group --shell /bin/bash dvdt
USER dvdt:dvdt
WORKDIR /home/dvdt

# Install Collective Knowledge (CK).
ENV CK_ROOT=/home/dvdt/CK \
    CK_REPOS=/home/dvdt/CK_REPOS \
    CK_TOOLS=/home/dvdt/CK_TOOLS \
    PATH=${CK_ROOT}/bin:/home/dvdt/.local/bin:${PATH} \
    CK_PYTHON=python3.7 \
    CK_CC=gcc \
    GIT_USER="dividiti" \
    GIT_EMAIL="info@dividiti.com" \
    LANG=C.UTF-8
RUN mkdir -p ${CK_ROOT} ${CK_REPOS} ${CK_TOOLS}
RUN git config --global user.name ${GIT_USER} && git config --global user.email ${GIT_EMAIL}
RUN git clone https://github.com/ctuning/ck.git ${CK_ROOT}
RUN cd ${CK_ROOT} \
 && ${CK_PYTHON} setup.py install --user \
 && ${CK_PYTHON} -c "import ck.kernel as ck; print ('Collective Knowledge v%s' % ck.__version__)"

# Pull CK repositories (including ck-env, ck-autotuning and ck-tensorflow).
RUN ck pull repo:ck-mlperf
RUN ck pull repo:ck-pytorch

# Use generic Linux settings with dummy frequency setting scripts.
RUN ck detect platform.os --platform_init_uoa=generic-linux-dummy

#-----------------------------------------------------------------------------#
# Step 1. Install C++ dependencies (FLAC, SoX).
#-----------------------------------------------------------------------------#
# Detect C/C++ compiler (gcc).
RUN ck detect soft:compiler.gcc --full_path=`which ${CK_CC}`
#- # Install preprocessing dependencies (FLAC, SoX).
#- RUN ck install package --tags=tool,flac
#- RUN ck install package --tags=tool,sox
#-----------------------------------------------------------------------------#


#-----------------------------------------------------------------------------#
# Step 2. Install Python dependencies (pip, Torch, SoX, pandas, Abseil, wheel).
#-----------------------------------------------------------------------------#
# Install the latest Python package installer (pip).
RUN ${CK_PYTHON} -m pip install --ignore-installed pip setuptools --user
# Detect Python interpreter ("compiler").
RUN ck detect soft:compiler.python --full_path=`which ${CK_PYTHON}`
# Install PyTorch.
RUN ck install package --tags=python-package,torch
# Install preprocessing dependencies (SoX, pandas).
RUN ck install package --tags=python-package,sox
RUN ck install package --tags=python-package,pandas
# Install LoadGen dependencies (Abseil, wheel).
RUN ck install package --tags=python-package,absl
RUN ${CK_PYTHON} -m pip install --user wheel
# Install other program dependencies.
# NB: Fix numba version: https://github.com/librosa/librosa/issues/1160
RUN ${CK_PYTHON} -m pip install --user tqdm toml unidecode inflect sndfile librosa numba==0.48
#-----------------------------------------------------------------------------#


#- #-----------------------------------------------------------------------------#
#- # Step 3. Download the official MLPerf Inference RNNT dataset (LibriSpeech
#- # dev-clean) and preprocess it to wav.
#- #-----------------------------------------------------------------------------#
#- RUN ck install package --tags=dataset,speech-recognition,dev-clean,original
#- # NB: Can ignore the lzma related warning.
#- RUN ck install package --tags=dataset,speech-recognition,dev-clean,preprocessed
#- #-----------------------------------------------------------------------------#


#- #-----------------------------------------------------------------------------#
#- # Step 4. Download the official MLPerf Inference RNNT model.
#- #----------------------------------------------------------------------------#
#- RUN ck install package --tags=model,pytorch,rnnt
#- #-----------------------------------------------------------------------------#


#-----------------------------------------------------------------------------#
# Step 5. Download the MLPerf Inference repo with dividiti's RNNT tweaks,
#- # and build the Python LoadGen API.
#-----------------------------------------------------------------------------#
RUN ck install package --tags=mlperf,inference,source,dividiti.rnnt
#- RUN ck install package --tags=python-package,loadgen
#-----------------------------------------------------------------------------#


#+ #-----------------------------------------------------------------------------#
#+ # Step 6. Pull all the implicit dependencies commented out in Steps 1-5.
#+ #-----------------------------------------------------------------------------#
RUN ck run program:speech-recognition-pytorch-loadgen --cmd_key=performance --skip_print_timers
#+ #-----------------------------------------------------------------------------#


#-----------------------------------------------------------------------------#
# Run the Speech Recognition RNNT program in the accuracy mode.
#-----------------------------------------------------------------------------#
CMD ["ck run program:speech-recognition-pytorch-loadgen --cmd_key=accuracy --skip_print_timers"]
