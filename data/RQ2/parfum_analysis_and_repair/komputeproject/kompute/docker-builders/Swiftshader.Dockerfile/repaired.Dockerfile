FROM ubuntu:18.04

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

# Dependencies for swiftshader
RUN apt-get install --no-install-recommends -y g++-8 gcc-8 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libx11-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxext-dev && rm -rf /var/lib/apt/lists/*;

# Run swiftshader via env VK_ICD_FILENAMES=/swiftshader/vk_swiftshader_icd.json
RUN git clone https://github.com/google/swiftshader swiftshader-build
RUN CC="/usr/bin/gcc-8" CXX="/usr/bin/g++-8" cmake swiftshader-build/. -Bswiftshader-build/build/
RUN cmake --build swiftshader-build/build/. --parallel
RUN cp -r swiftshader-build/build/Linux/ swiftshader/

