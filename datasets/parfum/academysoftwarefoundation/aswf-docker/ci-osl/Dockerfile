# syntax=docker/dockerfile:1.3-labs
# Copyright (c) Contributors to the aswf-docker Project. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

# !!! This file is automatically generated from a template and the `image.yaml` file in the same folder !!!

ARG ASWF_ORG
ARG ASWF_PKG_ORG
ARG CI_COMMON_VERSION
ARG ASWF_CLANG_MAJOR_VERSION
ARG ASWF_CONAN_CHANNEL

ARG ASWF_VFXPLATFORM_VERSION


ARG ASWF_BOOST_VERSION
ARG ASWF_CMAKE_VERSION
ARG ASWF_PYTHON_VERSION
ARG ASWF_QT_VERSION
ARG ASWF_IMATH_VERSION
ARG ASWF_OPENEXR_VERSION
ARG ASWF_OIIO_VERSION
ARG ASWF_OCIO_VERSION
ARG ASWF_PARTIO_VERSION
ARG ASWF_TBB_VERSION
ARG ASWF_BLOSC_VERSION
ARG ASWF_OPENVDB_VERSION
ARG ASWF_NUMPY_VERSION
ARG ASWF_VFXPLATFORM_VERSION
ARG ASWF_PYTHON_MAJOR_MINOR_VERSION


# Comment out this block to use Conan packages
FROM ${ASWF_PKG_ORG}/ci-package-boost:$ASWF_VFXPLATFORM_VERSION-$ASWF_BOOST_VERSION as ci-package-boost
FROM ${ASWF_PKG_ORG}/ci-package-cmake:$ASWF_VFXPLATFORM_VERSION-$ASWF_CMAKE_VERSION as ci-package-cmake
FROM ${ASWF_PKG_ORG}/ci-package-python:$ASWF_VFXPLATFORM_VERSION-$ASWF_PYTHON_VERSION as ci-package-python
FROM ${ASWF_PKG_ORG}/ci-package-qt:$ASWF_VFXPLATFORM_VERSION-$ASWF_QT_VERSION as ci-package-qt
FROM ${ASWF_PKG_ORG}/ci-package-imath:$ASWF_VFXPLATFORM_VERSION-$ASWF_IMATH_VERSION as ci-package-imath
FROM ${ASWF_PKG_ORG}/ci-package-openexr:$ASWF_VFXPLATFORM_VERSION-$ASWF_OPENEXR_VERSION as ci-package-openexr
FROM ${ASWF_PKG_ORG}/ci-package-oiio:$ASWF_VFXPLATFORM_VERSION-$ASWF_OIIO_VERSION as ci-package-oiio
FROM ${ASWF_PKG_ORG}/ci-package-ocio:$ASWF_VFXPLATFORM_VERSION-$ASWF_OCIO_VERSION as ci-package-ocio
FROM ${ASWF_PKG_ORG}/ci-package-partio:$ASWF_VFXPLATFORM_VERSION-$ASWF_PARTIO_VERSION as ci-package-partio
FROM ${ASWF_PKG_ORG}/ci-package-tbb:$ASWF_VFXPLATFORM_VERSION-$ASWF_TBB_VERSION as ci-package-tbb
FROM ${ASWF_PKG_ORG}/ci-package-blosc:$ASWF_VFXPLATFORM_VERSION-$ASWF_BLOSC_VERSION as ci-package-blosc
FROM ${ASWF_PKG_ORG}/ci-package-openvdb:$ASWF_VFXPLATFORM_VERSION-$ASWF_OPENVDB_VERSION as ci-package-openvdb
FROM ${ASWF_ORG}/ci-common:${CI_COMMON_VERSION}-clang${ASWF_CLANG_MAJOR_VERSION} as ci-osl


ARG ASWF_ORG
ARG ASWF_PKG_ORG
ARG ASWF_VERSION
ARG CI_COMMON_VERSION
ARG ASWF_CONAN_CHANNEL

ARG ASWF_BOOST_VERSION
ARG ASWF_CMAKE_VERSION
ARG ASWF_PYTHON_VERSION
ARG ASWF_QT_VERSION
ARG ASWF_IMATH_VERSION
ARG ASWF_OPENEXR_VERSION
ARG ASWF_OIIO_VERSION
ARG ASWF_OCIO_VERSION
ARG ASWF_PARTIO_VERSION
ARG ASWF_TBB_VERSION
ARG ASWF_BLOSC_VERSION
ARG ASWF_OPENVDB_VERSION
ARG ASWF_NUMPY_VERSION
ARG ASWF_VFXPLATFORM_VERSION
ARG ASWF_PYTHON_MAJOR_MINOR_VERSION


LABEL org.opencontainers.image.name="$ASWF_ORG/ci-osl"
LABEL org.opencontainers.image.title="OpenShadingLanguage CI Docker Image"
LABEL org.opencontainers.image.description="Contains: Python, Boost, Qt, OpenEXR, OpenImageIO, Partio and other OpenShadingLanguage upstream dependencies\
Warning: this image does *not* contain OpenShadingLanguage itself as it is used to *build* OpenShadingLanguage!"
LABEL org.opencontainers.image.url="http://aswf.io/"
LABEL org.opencontainers.image.source="https://github.com/AcademySoftwareFoundation/aswf-docker/blob/master/ci-osl/Dockerfile"
LABEL org.opencontainers.image.vendor="AcademySoftwareFoundation"
LABEL org.opencontainers.image.authors="Built by aswf.io CI Working Group"
LABEL org.opencontainers.image.version="${ASWF_VERSION}"


LABEL com.vfxplatform.version="${ASWF_VFXPLATFORM_VERSION}"


LABEL io.aswf.docker.versions.boost="$ASWF_BOOST_VERSION"
LABEL io.aswf.docker.versions.cmake="$ASWF_CMAKE_VERSION"
LABEL io.aswf.docker.versions.python="$ASWF_PYTHON_VERSION"
LABEL io.aswf.docker.versions.qt="$ASWF_QT_VERSION"
LABEL io.aswf.docker.versions.imath="$ASWF_IMATH_VERSION"
LABEL io.aswf.docker.versions.openexr="$ASWF_OPENEXR_VERSION"
LABEL io.aswf.docker.versions.oiio="$ASWF_OIIO_VERSION"
LABEL io.aswf.docker.versions.ocio="$ASWF_OCIO_VERSION"
LABEL io.aswf.docker.versions.partio="$ASWF_PARTIO_VERSION"
LABEL io.aswf.docker.versions.tbb="$ASWF_TBB_VERSION"
LABEL io.aswf.docker.versions.blosc="$ASWF_BLOSC_VERSION"
LABEL io.aswf.docker.versions.openvdb="$ASWF_OPENVDB_VERSION"
LABEL io.aswf.docker.versions.numpy="$ASWF_NUMPY_VERSION"
LABEL io.aswf.docker.versions.vfxplatform="$ASWF_VFXPLATFORM_VERSION"


ENV ASWF_ORG=${ASWF_ORG}
ENV ASWF_VERSION=${ASWF_VERSION}

ENV ASWF_VFXPLATFORM_VERSION=${ASWF_VFXPLATFORM_VERSION}


ENV ASWF_BOOST_VERSION=$ASWF_BOOST_VERSION
ENV ASWF_CMAKE_VERSION=$ASWF_CMAKE_VERSION
ENV ASWF_PYTHON_VERSION=$ASWF_PYTHON_VERSION
ENV ASWF_QT_VERSION=$ASWF_QT_VERSION
ENV ASWF_IMATH_VERSION=$ASWF_IMATH_VERSION
ENV ASWF_OPENEXR_VERSION=$ASWF_OPENEXR_VERSION
ENV ASWF_OIIO_VERSION=$ASWF_OIIO_VERSION
ENV ASWF_OCIO_VERSION=$ASWF_OCIO_VERSION
ENV ASWF_PARTIO_VERSION=$ASWF_PARTIO_VERSION
ENV ASWF_TBB_VERSION=$ASWF_TBB_VERSION
ENV ASWF_BLOSC_VERSION=$ASWF_BLOSC_VERSION
ENV ASWF_OPENVDB_VERSION=$ASWF_OPENVDB_VERSION
ENV ASWF_NUMPY_VERSION=$ASWF_NUMPY_VERSION
ENV ASWF_VFXPLATFORM_VERSION=$ASWF_VFXPLATFORM_VERSION
ENV ASWF_PYTHON_MAJOR_MINOR_VERSION=$ASWF_PYTHON_MAJOR_MINOR_VERSION


# Comment out this block to use Conan packages
COPY --from=ci-package-boost /. /usr/local/
COPY --from=ci-package-cmake /. /usr/local/
COPY --from=ci-package-python /. /usr/local/
COPY --from=ci-package-qt /. /usr/local/
COPY --from=ci-package-imath /. /usr/local/
COPY --from=ci-package-openexr /. /usr/local/
COPY --from=ci-package-oiio /. /usr/local/
COPY --from=ci-package-ocio /. /usr/local/
COPY --from=ci-package-partio /. /usr/local/
COPY --from=ci-package-tbb /. /usr/local/
COPY --from=ci-package-blosc /. /usr/local/
COPY --from=ci-package-openvdb /. /usr/local/
COPY ci-osl/README.md ci-osl/image.yaml /usr/local/aswf/



ENV PYTHONPATH=/usr/local/lib/python${ASWF_PYTHON_MAJOR_MINOR_VERSION}/site-packages:/usr/local/lib64/python${ASWF_PYTHON_MAJOR_MINOR_VERSION}/site-packages:/usr/local/lib/python:${PYTHONPATH}

RUN conan config set general.default_profile=vfx${ASWF_VFXPLATFORM_VERSION}



# conan-only packages
COPY <<EOF /usr/local/conanfile.txt
[generators]
[imports]
., * -> .
[requires]
# Uncomment to use Conan packages instead of Docker ones
# boost/${ASWF_BOOST_VERSION}@${ASWF_PKG_ORG}/${ASWF_CONAN_CHANNEL}
# cmake/${ASWF_CMAKE_VERSION}@${ASWF_PKG_ORG}/${ASWF_CONAN_CHANNEL}
# python/${ASWF_PYTHON_VERSION}@${ASWF_PKG_ORG}/${ASWF_CONAN_CHANNEL}
# qt/${ASWF_QT_VERSION}@${ASWF_PKG_ORG}/${ASWF_CONAN_CHANNEL}
# imath/${ASWF_IMATH_VERSION}@${ASWF_PKG_ORG}/${ASWF_CONAN_CHANNEL}
# openexr/${ASWF_OPENEXR_VERSION}@${ASWF_PKG_ORG}/${ASWF_CONAN_CHANNEL}
# oiio/${ASWF_OIIO_VERSION}@${ASWF_PKG_ORG}/${ASWF_CONAN_CHANNEL}
# ocio/${ASWF_OCIO_VERSION}@${ASWF_PKG_ORG}/${ASWF_CONAN_CHANNEL}
# partio/${ASWF_PARTIO_VERSION}@${ASWF_PKG_ORG}/${ASWF_CONAN_CHANNEL}
# tbb/${ASWF_TBB_VERSION}@${ASWF_PKG_ORG}/${ASWF_CONAN_CHANNEL}
# blosc/${ASWF_BLOSC_VERSION}@${ASWF_PKG_ORG}/${ASWF_CONAN_CHANNEL}
# openvdb/${ASWF_OPENVDB_VERSION}@${ASWF_PKG_ORG}/${ASWF_CONAN_CHANNEL}
EOF

RUN <<EOF
cd /usr/local/
conan install .
EOF