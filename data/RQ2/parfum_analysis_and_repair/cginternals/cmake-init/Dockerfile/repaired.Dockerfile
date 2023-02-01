ARG BASE=ubuntu:20.04
ARG PROJECT_NAME=cmake-init
ARG WORKSPACE=/workspace

# BUILD

FROM $BASE AS cmake-init-build

ARG PROJECT_NAME
ARG WORKSPACE
ARG COMPILER_FLAGS="-j 4"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y --no-install-recommends sudo \
    && echo 'user ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/user && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends cmake git build-essential && rm -rf /var/lib/apt/lists/*;

ENV PROJECT_DIR="$WORKSPACE/$PROJECT_NAME"

WORKDIR $WORKSPACE

ADD cmake $PROJECT_NAME/cmake
ADD docs $PROJECT_NAME/docs
ADD data $PROJECT_NAME/data
ADD deploy $PROJECT_NAME/deploy
ADD source $PROJECT_NAME/source
ADD CMakeLists.txt $PROJECT_NAME/CMakeLists.txt
ADD configure $PROJECT_NAME/configure
ADD template-config.cmake $PROJECT_NAME/template-config.cmake
ADD $PROJECT_NAME-logo.png $PROJECT_NAME/$PROJECT_NAME-logo.png
ADD $PROJECT_NAME-logo.svg $PROJECT_NAME/$PROJECT_NAME-logo.svg
ADD LICENSE $PROJECT_NAME/LICENSE
ADD README.md $PROJECT_NAME/README.md
ADD AUTHORS $PROJECT_NAME/AUTHORS

WORKDIR $PROJECT_DIR
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN CMAKE_OPTIONS="-DOPTION_BUILD_TESTS=Off -DCMAKE_INSTALL_PREFIX=$WORKSPACE/$PROJECT_NAME-install" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN cmake --build build -- $COMPILER_FLAGS
RUN cmake --build build --target install

# DEPLOY

FROM $BASE AS cmake-init

ARG PROJECT_NAME
ARG WORKSPACE

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y --no-install-recommends cmake && rm -rf /var/lib/apt/lists/*;

COPY --from=cmake-init-build $WORKSPACE/$PROJECT_NAME-install $WORKSPACE/$PROJECT_NAME
