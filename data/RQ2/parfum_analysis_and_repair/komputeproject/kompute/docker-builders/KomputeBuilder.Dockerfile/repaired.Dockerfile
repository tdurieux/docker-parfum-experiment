FROM ubuntu:20.04

# Base packages from default ppa
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gnupg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

# Repository to latest cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'

# Repository for latest git (needed for gh actions)
RUN add-apt-repository -y ppa:git-core/ppa

# Refresh repositories
RUN apt update -y

RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libvulkan-dev && rm -rf /var/lib/apt/lists/*;
# Swiftshader dependencies
RUN apt-get install --no-install-recommends -y libx11-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxext-dev && rm -rf /var/lib/apt/lists/*;

COPY --from=axsauze/swiftshader:0.1 /swiftshader/ /swiftshader/

# GLSLANG tools for tests
RUN apt-get install --no-install-recommends -y glslang-tools && rm -rf /var/lib/apt/lists/*;

# Setup Python
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

RUN mkdir builder
WORKDIR /builder


