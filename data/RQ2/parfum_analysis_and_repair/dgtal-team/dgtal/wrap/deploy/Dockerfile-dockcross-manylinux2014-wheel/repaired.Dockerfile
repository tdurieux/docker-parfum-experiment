FROM phcerdan/dgtal-linux-dependencies
LABEL MAINTAINER="Pablo Hernandez Cerdan <pablo.hernandez.cerdan@outlook.com>"

#### Global Variables
ENV BUILD_PATH /work
ENV DGTAL_CMAKE_BUILD_TYPE Release

ENV DGTAL_BUILD_DIR ${BUILD_PATH}/DGtal-build
ENV DGTAL_SRC_FOLDER_NAME DGtal-src
ENV DGTAL_SRC_DIR ${BUILD_PATH}/${DGTAL_SRC_FOLDER_NAME}

COPY . ${DGTAL_SRC_DIR}

############# DGtal #############
WORKDIR $BUILD_PATH
RUN ${DGTAL_SRC_DIR}/wrap/deploy/manylinux-build-wheels.sh

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG IMAGE=dgtal-linux-wheel
ARG VERSION=latest
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.version=$VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0" \
      build_command="\
      docker build -f ./wrap/deploy/Dockerfile-dockcross-manylinux2014-wheel . -t phcerdan/dgtal-linux-wheel; \
      docker cp $(docker create phcerdan/dgtal-linux-wheel:latest):/work/dist /tmp"