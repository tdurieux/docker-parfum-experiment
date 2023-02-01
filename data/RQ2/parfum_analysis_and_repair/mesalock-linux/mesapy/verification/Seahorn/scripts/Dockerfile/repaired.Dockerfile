# Dockerfile for Seahorn

# OS image
FROM ubuntu:14.04

ENV SEAHORN=/home/seahorn/seahorn_bin
ENV PATH="/home/seahorn/seahorn/bin:$PATH"

# Install
RUN \
  sudo apt-get update -qq && \
  sudo apt-get upgrade -qq && \
  sudo apt-get install -y --no-install-recommends bridge-utils && \
  apt-get install -y --no-install-recommends -qq build-essential clang-3.6 && \
  apt-get install -y --no-install-recommends -qq software-properties-common && \
  apt-get install -y --no-install-recommends -qq curl git ninja-build man subversion vim wget cmake && \
  apt-get install -y --no-install-recommends -qq libboost-program-options-dev && \
  apt-get install --no-install-recommends python2.7 python2.7-dev -y && \
  apt-get install --no-install-recommends -y libboost1.55-all-dev && \
  apt-get install --no-install-recommends --yes libgmp-dev && \
  apt-get install --no-install-recommends --yes python-pip && rm -rf /var/lib/apt/lists/*;

RUN \
  export LZ="$TRAVIS_BUILD_DIR/../lz" && \
  mkdir -p $LZ && \
  wget --output-document=llvm-z3.tar.gz https://www.dropbox.com/s/cipjz38k3boyd1v/llvm-3.6-z3.tar.gz?dl=1 && \
  tar xvf llvm-z3.tar.gz -C $LZ && \
  ls $LZ && \
  sudo pip install --no-cache-dir lit && \
  sudo pip install --no-cache-dir OutputCheck && rm llvm-z3.tar.gz


RUN \
  git clone https://github.com/seahorn/seahorn && \
  cd seahorn && \
  ls && \
  mkdir -p build && \
  cd build && \
  mv $LZ/run run && \
  /usr/bin/cmake -DBOOST_ROOT=$BOOST_ROOT -DZ3_ROOT=run -DLLVM_DIR=$(pwd)/run/share/llvm/cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PROGRAM_PATH=/usr/bin  -DCMAKE_INSTALL_PREFIX=run ../ && \
  /usr/bin/cmake --build . --target extra && \
  ls ../ && \
  /usr/bin/cmake --build . && \
  /usr/bin/cmake --build . && \
  /usr/bin/cmake --build . --target install && \
  ls run/bin/ && \
  run/bin/sea -h && \
  /usr/bin/cmake --build . --target test-simple

# Install
RUN \
  sudo apt-get update && \
  apt-get install --no-install-recommends python2.7 python2.7-dev -y && \
  apt-get install --no-install-recommends --yes python-pip && \
  sudo pip install --no-cache-dir wllvm && \
  export LLVM_COMPILER=clang && \
  apt-get install --no-install-recommends --yes gcc make libffi-dev pkg-config libz-dev libbz2-dev libsqlite3-dev libexpat1-dev libssl-dev libgdbm-dev tk-dev libgc-dev python-cffi liblzma-dev libncurses5-dev && rm -rf /var/lib/apt/lists/*;
RUN \
  sudo apt-get update && \
  sudo apt-get install --no-install-recommends python-software-properties software-properties-common -y -f && \
  sudo add-apt-repository ppa:pypy/ppa -y && \
  sudo apt-get update && \
  apt-get install --no-install-recommends pypy -y && \
  apt-get install --no-install-recommends python-pip python-dev build-essential -y && \
  apt-get install --no-install-recommends --yes git && \
  sudo apt-get install --no-install-recommends --yes mercurial && \
  hg clone http://bitbucket.org/pypy/pypy pypy && \
  cd /pypy/pypy/goal && rm -rf /var/lib/apt/lists/*;
  #git clone -b release-pypy2.7-v6.0.0 https://github.com/mesalock-linux/mesapy.git
  pypy ../../rpython/bin/rpython --opt=jit targetpypystandalone.py
