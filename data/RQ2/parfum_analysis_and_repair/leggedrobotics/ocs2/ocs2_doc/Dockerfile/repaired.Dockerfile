FROM ros:noetic

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y \
    doxygen \
    python3-pip \
    git \
    rsync \
    wget \
    curl && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir \
  sphinx \
  breathe \
  sphinx-rtd-theme \
  sphinxcontrib.bibtex
