FROM ubuntu:21.10

ENV DEBIAN_FRONTEND noninteractive

RUN  dpkg --add-architecture i386 &&  apt-get update
## apt-get upgrade -y
RUN apt-get install --no-install-recommends -y libboost-all-dev libjsoncpp-dev openjdk-11-jdk libc6:i386 libstdc++6:i386 zipalign apksigner python3.10 && rm -rf /var/lib/apt/lists/*;

## Installing git-lfs
RUN apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

ENV os ubuntu
ENV dist trustly

RUN curl -f -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh >> ./script.sh && bash -c os=ubuntu dist=trusty ./script.sh && apt-get install --no-install-recommends git-lfs -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/Gyoonus/deoptfuscator.git
