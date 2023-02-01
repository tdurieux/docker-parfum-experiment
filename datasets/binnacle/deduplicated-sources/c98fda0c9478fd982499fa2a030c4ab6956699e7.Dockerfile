FROM arnislielturks/urho3d:10
MAINTAINER Arnis Lielturks <arnis@example.com>

COPY bin /code/bin
COPY Source /code/Source
COPY CMakeLists.txt /code/CMakeLists.txt
COPY CMake /code/CMake
COPY script /code/script

# Install all the dependencies
RUN apt-get update \
    && apt-get install -y curl zip \
    && apt-get purge --auto-remove -y && apt-get clean

RUN cd /code \
    && bash ./script/cmake_mingw.sh build-windows -DURHO3D_HOME=/Urho3D/build-windows -DURHO3D_HASH_DEBUG=0 -DURHO3D_PROFILING=0 -DMINGW_PREFIX=/usr/bin/x86_64-w64-mingw32 -DDIRECTX_LIB_SEARCH_PATHS=/usr/bin/x86-w64-mingw32/lib -DCMAKE_BUILD_TYPE=Release -DURHO3D_DEPLOYMENT_TARGET=generic || true \
    && cd build-windows && make -j 2 \
    && cd ..

ARG SITE_URL="https://mods.frameskippers.com"
ARG SITE_TOKEN=123
ARG BUILD_NUMBER=1
ARG BUILD_DESCRIPTION="Docker automated build"

RUN cd /code \
    && mkdir archive \
    && pwd \
    && cp build-windows/bin/EmptyProject.exe archive/EmptyProject.exe || true \
    && cp build-windows/bin/EmptyProject_d.exe archive/EmptyProject_d.exe || true \
    && cp -r bin/Data archive/Data \
    && cp -r bin/CoreData archive/CoreData \
    && rm -rf archive/Data/Saves/Achievements.json \
    && chmod -R 777 archive \
    && cd archive \
    && zip -r "build.zip" *  > /dev/null \
    && curl -X POST \
        -H "Content-Type: multipart/form-data" \
        -F file=@build.zip \
        -F build=${BUILD_NUMBER} \
        -F platform=windows \
        -F description=${BUILD_DESCRIPTION} \
        -F token=$SITE_TOKEN \
        $SITE_URL || true
