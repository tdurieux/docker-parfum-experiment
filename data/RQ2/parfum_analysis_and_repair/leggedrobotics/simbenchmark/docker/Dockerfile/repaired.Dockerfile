FROM ubuntu:16.04

RUN apt-get update -qq && apt-get -y -qq upgrade

# essentials
RUN apt-get install --no-install-recommends -y -qq build-essential git software-properties-common && rm -rf /var/lib/apt/lists/*;

# cmake
RUN apt-get install --no-install-recommends -y -qq cmake && rm -rf /var/lib/apt/lists/*;

# g++
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install --no-install-recommends -y -qq g++-7 g++-6 && rm -rf /var/lib/apt/lists/*;

# other dependencies
RUN apt-get install --no-install-recommends -y -qq libeigen3-dev libboost-all-dev libglew-dev libglm-dev libsdl2-dev \
libassimp-dev libsoil-dev libsdl2-ttf-dev && rm -rf /var/lib/apt/lists/*;

# raicommon dependencies
RUN apt-get install --no-install-recommends -y -qq gnuplot5 && rm -rf /var/lib/apt/lists/*;

# raigraphics dependencies
RUN apt-get install --no-install-recommends -y -qq libsdl2-image-dev ffmpeg && rm -rf /var/lib/apt/lists/*;

# urdf-dom
RUN apt-get install --no-install-recommends -y -qq liburdfdom-dev && rm -rf /var/lib/apt/lists/*;

# dart dependencies
RUN apt-get remove -y libdart*
RUN apt-get install --no-install-recommends -y libassimp-dev libccd-dev libfcl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libopenscenegraph-dev && rm -rf /var/lib/apt/lists/*;