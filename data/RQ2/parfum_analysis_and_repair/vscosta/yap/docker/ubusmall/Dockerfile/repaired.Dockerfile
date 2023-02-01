# Use an official Python runtime as a parent image
FROM ubuntu AS yap-srl

ENV TZ=Europe/Lisbon
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone



# Set the working directory to /srl
WORKDIR /srl
WORKDIR /srl/cudd
WORKDIR /srl/data

RUN apt update && apt -y upgrade && apt -y --no-install-recommends install \

    git gcc g++ make cmake \

    autotools-dev automake autoconf perl-base m4 doxygen flex bison \

    libreadline-dev libgmp-dev \

    openmpi-bin libopenmpi-dev \
    libgecode-dev && rm -rf /var/lib/apt/lists/*;
    # R support

#yap binary

RUN git clone https://github.com/vscosta/cudd.git /srl/cudd \
    && cd /srl/cudd \
    && aclocal\
    && automake \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --enable-shared --enable-obj --enable-dddmp && make -j install && cd ..

RUN  git clone https://github.com/vscosta/yap /srl/yap --depth=6\
    && mkdir -p /srl/yap/build\
    && cd /srl/yap/build\
    && cmake .. -DWITH_DOXYGEN=1  -DWITH_PACKAGES=0 -DWITH_BDD=1 -DWITH_PROBLOG=1 -DWITH_GECODE=1 -DWITH_CLPBN=1 -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    && cmake --build . --parallel --target install

RUN mkdir -p /srl/data
RUN cp -a ~/ilp/UPAleph  /srl/UPAleph     
RUN cp -a ~/ilp/skill_base  /srl/skill_base
RUN cp -a ~/ilp/v2  /srl/data/chemojs
RUN cp -a ~/ilp/uw-aleph  /srl/data/uw-cse



# Make port 80 available to the world outside this container
EXPOSE 22

