#
# Preinstall things, or setup your development environment.
# You may wish to tailor this file to your own configuration to speed up deployment,
# however try not to commit those changes to the repo.
#

RUN pip install --no-cache-dir ipdb

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    htop \
    tree \
    python3-dbg \
    gdb \
    strace && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    silversearcher-ag \
    vim && rm -rf /var/lib/apt/lists/*;
USER ${RLSCOPE_USER}