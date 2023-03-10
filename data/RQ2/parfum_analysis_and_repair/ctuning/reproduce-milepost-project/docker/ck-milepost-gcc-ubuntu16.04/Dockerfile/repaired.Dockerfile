FROM ubuntu:16.04
MAINTAINER Grigori Fursin <Grigori.Fursin@cTuning.org>

# Install standard packages.
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-all \
    git bzip2 sudo wget zip && rm -rf /var/lib/apt/lists/*;

# Install extra deps for imaging
RUN apt-get install --no-install-recommends -y libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev python-pillow && rm -rf /var/lib/apt/lists/*;

# Install extra deps to build compiler
RUN apt-get install --no-install-recommends -y build-essential automake autoconf libncurses-dev uuid-runtime m4 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc g++ g++-multilib libc6-dev-i386 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y texinfo libisl-dev libcloog-isl-dev libmpc-dev libgmp-dev libmpfr-dev && rm -rf /var/lib/apt/lists/*;

# Install the core Collective Knowledge (CK) module.
ENV CK_ROOT=/ck-master \
    CK_REPOS=/CK \
    CK_TOOLS=/CK-TOOLS \
    PATH=${CK_ROOT}/bin:${PATH}

RUN mkdir -p ${CK_ROOT} ${CK_REPOS} ${CK_TOOLS}
RUN git clone https://github.com/ctuning/ck.git ${CK_ROOT}
RUN cd ${CK_ROOT} && python setup.py install && python -c "import ck.kernel as ck"

# Install CK MILEPOST repo
RUN ck  version
RUN ck pull repo:reproduce-milepost-project

# Build MILEPOST GCC and all deps
RUN ck install package:compiler-gcc-4.4.4-milepost-src-deps

# Build cTuning CC wrapper for MILEPOST GCC
RUN ck install package:compiler-ctuning-cc-2.5-plugins-src
RUN ck install package:compiler-ctuning-cc-2.5-src

#
CMD bash
