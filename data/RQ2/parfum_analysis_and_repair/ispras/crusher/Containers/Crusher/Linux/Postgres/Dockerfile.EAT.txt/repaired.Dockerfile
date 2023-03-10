#Basic Image
FROM ubuntu:20.04

#Args for compliance of inner and outer uid and gid

ARG cuid=1000
ARG cgid=1000
ARG cuidname=crusher
ARG cgidname=crusher

#Just a notes
LABEL maintainer="ponomarev@fobos-nt.ru"
LABEL version="1.0"
LABEL description="Boilerplate for crusher EAT work"

#Install system packages
RUN apt update && apt install --no-install-recommends -y gcc clang llvm make sudo git wget && rm -rf /var/lib/apt/lists/*;

#Add group and user (like my HOST group and user)
RUN groupadd -g $cgid $cgidname &&  useradd -m -u $cuid -g $cgidname -G sudo -s /usr/bin/bash $cuidname

#Unpack Crusher
ADD crusher.tar.gz /home/$cuidname

#Compile afl++ compilers
WORKDIR /home/$cuidname
RUN wget https://github.com/AFLplusplus/AFLplusplus/archive/3.0c.tar.gz \
    && tar xvf 3.0c.tar.gz && rm 3.0c.tar.gz
WORKDIR /home/$cuidname/AFLplusplus-3.0c
RUN make -j10

#Getting inputs from HOST
WORKDIR /home/$cuidname
COPY in in/

################### Add your target here
#Set Timezone or get hang during the docker build...
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Install Target for fuzzing
RUN apt install --no-install-recommends -y libreadline-dev zlib1g-dev bison flex libfl-dev && rm -rf /var/lib/apt/lists/*;
USER $cuidname
RUN git clone --single-branch --branch REL_12_STABLE --depth 1 https://github.com/postgres/postgres
WORKDIR /home/$cuidname/postgres

#Configuring and compiling the Target for fuzzing
RUN CC=/home/$cuidname/AFLplusplus-3.0c/afl-clang-fast CXX=/home/$cuidname/AFLplusplus-3.0c/afl-clang-fast++ AFL_USE_UBSAN=1 AFL_LLVM_LAF_ALL=1 ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix /home/$cuidname/pgbuild
RUN make -j10 && make install
WORKDIR /home/$cuidname/

RUN /home/$cuidname/pgbuild/bin/initdb -D /home/$cuidname/data

###################

#Start fuzzer in a container (change ownership for output folder)
USER root
ENV cuidname=$cuidname
ENV cgidname=$cgidname
CMD echo core >/proc/sys/kernel/core_pattern && chown -R $cuidname:$cgidname /home/$cuidname/out && sudo -u $cuidname ./crusher/bin_x86-64/eat -o out/ -F -I StaticForkSrv --bitmap-size 150000 -T stdin -t 3000 -- /home/$cuidname/pgbuild/bin/postgres --single -D /home/$cuidname/data postgres
