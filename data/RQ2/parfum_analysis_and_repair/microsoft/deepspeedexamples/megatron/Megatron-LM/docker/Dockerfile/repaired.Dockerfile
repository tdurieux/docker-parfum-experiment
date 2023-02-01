# ===========
# base images
# ===========
FROM nvcr.io/nvidia/pytorch:19.05-py3


# ===============
# system packages
# ===============
RUN apt-get update && apt-get install --no-install-recommends -y \
    bash-completion \
    emacs \
    git \
    graphviz \
    htop \
    libopenexr-dev \
    rsync \
    wget \
&& rm -rf /var/lib/apt/lists/*


# ============
# pip packages
# ============
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --upgrade setuptools
COPY requirements.txt /tmp/
RUN pip install --no-cache-dir --upgrade --ignore-installed -r /tmp/requirements.txt


# ===========
# latest apex
# ===========
RUN pip uninstall -y apex && \
git clone https://github.com/NVIDIA/apex.git ~/apex && \
cd ~/apex && \
pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" .

