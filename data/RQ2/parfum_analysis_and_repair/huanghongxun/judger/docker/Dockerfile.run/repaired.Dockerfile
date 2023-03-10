FROM ubuntu:18.04

RUN apt update && apt install --no-install-recommends -y libcgroup-dev libcurl4-openssl-dev curl make xz-utils python3 libboost-all-dev cmake libgtest-dev gcc-8 g++-8 libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/chroot
COPY exec/chroot_make.sh ./
RUN bash chroot_make.sh -d /chroot -R disco -M http://mirrors.vmatrix.org.cn/ubuntu

WORKDIR /opt/judge-system
COPY . ./
RUN useradd -d /nonexistent -U -M -s /bin/false domjudge-run && bash ./exec/create_cgroups.sh domjudge-run
WORKDIR /opt/judge-system/build
RUN CC=gcc-8 CXX=g++-8 cmake -DBUILD_ENTRY=ON .. && make
WORKDIR /opt/judge-system/runguard/build
RUN CC=gcc-8 CXX=g++-8 cmake -DBUILD_ENTRY=ON .. && make

ENTRYPOINT ["/opt/judge-system/run.sh"]
