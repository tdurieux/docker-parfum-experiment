from ubuntu:16.04

#################################
#                               #
# Vapor configuration and build #
#                               #
#################################

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl \
    && apt-get install --no-install-recommends -y xz-utils \
    && apt-get install --no-install-recommends -y git \
    && apt-get install --no-install-recommends -y cmake \
    && apt-get install --no-install-recommends -y g++ \
# need freglut3-dev due to error Could NOT find OpenGL (missing: OPENGL_gl_LIBRARY OPENGL_INCLUDE_DIR)
# https://stackoverflow.com/questions/31170869/cmake-could-not-find-opengl-in-ubuntu
    && apt-get install --no-install-recommends -y freeglut3-dev \
# Aren't we supposed to be distributing libexpat in our third-party tar???
    && apt-get install --no-install-recommends -y libexpat1-dev \
    && apt-get install --no-install-recommends -y libglib2.0-0 \
    && apt-get install --no-install-recommends -y libdbus-1-3 && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/local/VAPOR-Deps

#Hack to download a file from google drive
RUN fileid="18KtuXQsy2J7pFvvZe0Ug-yjnEmlPiE2p" \
    && filename="/usr/local/VAPOR-Deps/2019-Aug-Ubuntu.tar.xz" \
    && curl -f -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" > /dev/null \
    && curl -f -Lb ./cookie \
    "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${fileid}" \
    -o ${filename}

RUN chmod -R 777 /usr

RUN ls -lrth /usr/local/VAPOR-Deps/

RUN tar -xf /usr/local/VAPOR-Deps/2019-Aug-Ubuntu.tar.xz \ 
    -C /usr/local/VAPOR-Deps \
    && chown -R root:root /usr && rm /usr/local/VAPOR-Deps/2019-Aug-Ubuntu.tar.xz

RUN chmod -R 777 /usr

RUN ls -lrth /usr/local/VAPOR-Deps/2019-Aug

RUN cd / \
    && git clone https://github.com/NCAR/VAPOR.git \
    && cd VAPOR \
    && cp site_files/site.NCAR site.local \
    && mkdir build

RUN cd /VAPOR/build \
    && export CMAKE_CXX_COMPILER=g++ \
    && cmake .. && make

WORKDIR /VAPOR
