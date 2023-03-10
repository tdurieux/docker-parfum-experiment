# LaTeX-On-HTTP intermediate Docker container,
# with the TexLive (& other compilers) distribution and Python runtime.
#
# This is:
# - a Texlive distribution (yoant/docker-texlive);
# - a selection of fonts;
# - a selection of TexLive packages;
# - libmq, with development headers;
# - a Python runtime/distribution.
FROM yoant/latexonhttp-tl-distrib:debian
LABEL maintainer="Yoan Tournade <yoan@ytotech.com>"

# git is used for some package installs.
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    git \
    libzmq5-dev \
    && apt-get autoremove --purge -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Update pip and install Pipenv.
RUN pip3 install --no-cache-dir -U \
  pip \
  pipenv

