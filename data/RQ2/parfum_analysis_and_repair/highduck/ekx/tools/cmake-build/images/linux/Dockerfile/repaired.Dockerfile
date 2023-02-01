FROM ubuntu:20.04

ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_15.x | bash
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive npm install --global yarn && npm cache clean --force;

RUN node --version
RUN npm --version
RUN yarn --version

RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends clang-10 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends llvm-10-dev -y && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/clang++-10 /usr/bin/clang++
RUN ln -s /usr/bin/clang-10 /usr/bin/clang
RUN ln -s /usr/bin/llvm-config-10 /usr/bin/llvm-config
RUN clang++ --version

RUN apt-get install --no-install-recommends ninja-build -y && rm -rf /var/lib/apt/lists/*;
RUN ninja --version

RUN curl -f -s "https://cmake.org/files/v3.19/cmake-3.19.4-Linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /usr/local
RUN cmake --version

RUN apt-get install --no-install-recommends xorg-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends freeglut3-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libopengl0 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
