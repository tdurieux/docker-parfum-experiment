FROM arm64v8/ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y
RUN apt-get install --no-install-recommends binutils build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python git fontconfig libfontconfig1-dev libglu1-mesa-dev libxrandr-dev libdbus-1-dev curl wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends openjdk-11-jdk -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends clang-11 -y && \
    apt-get remove g++ -y && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-11 100 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;

# Install libs & tools
ENV DEPOT_TOOLS=/usr/depot_tools
ENV PATH=$DEPOT_TOOLS:$PATH
RUN git clone 'https://chromium.googlesource.com/chromium/tools/depot_tools.git' $DEPOT_TOOLS

# Use UTF-8 by default
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF