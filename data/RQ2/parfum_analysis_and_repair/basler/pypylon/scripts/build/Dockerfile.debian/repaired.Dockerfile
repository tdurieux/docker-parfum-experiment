ARG QEMU_TARGET_ARCH
ARG DOCKER_BASE_IMAGE

#the following lines are used to get a qemu binary only with docker tools
FROM multiarch/qemu-user-static:4.2.0-6 as qemu

FROM $DOCKER_BASE_IMAGE
ARG CMD_WRAPPER
COPY --from=qemu /usr/bin/* /usr/bin/

# Quick fix for the now archived debian jessie. Security updates are also no longer provided for arm64.
# We switch all sources to the debian archive servers, See:
# https://github.com/debuerreotype/docker-debian-artifacts/issues/66
# https://stackoverflow.com/questions/55386246/w-failed-to-fetch-http-deb-debian-org-debian-dists-jessie-updates-main-binary
RUN if cat /etc/debian_version | grep -q "8\." ; then \
        echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie main" > /etc/apt/sources.list; \
        apt-get -o Acquire::Check-Valid-Until=false update; \
    fi

RUN pip install --no-cache-dir wheel auditwheel
#build a new swig
RUN mkdir /build && \
    cd /build && \
    wget https://prdownloads.sourceforge.net/swig/swig-4.0.1.tar.gz && \
    tar -xzf swig-4.0.1.tar.gz && cd swig-4.0.1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-python3 && make -j2 && make install && \
    rm -rf /build && rm swig-4.0.1.tar.gz

# numpy is required for the pypylon unittests
# currently disabled because the numpy install exceeds the current travis max duration
# RUN pip install numpy

# one genicam unittest requires a french locale
# patchelf, unzip are needed for auditwheel
RUN apt-get update && apt-get install --no-install-recommends -y locales patchelf unzip \
 && rm -rf /var/lib/apt/lists/* \
 && sed -i 's/^# *\(fr_FR.UTF-8\)/\1/' /etc/locale.gen \
 && locale-gen

RUN mkdir /work
RUN mkdir /pylon_installer
RUN mkdir /worker_home && chmod go+rwx /worker_home
ENV HOME=/worker_home


# run everything wrapped using CMD_WRAPPER
# In most cases the wrapper is linux64/32.
# This is for example required when running the armv7 container on armv8 hardware to ensure that python really builds for armv7
RUN echo "#!/bin/sh" > /entrypoint.sh; echo exec $CMD_WRAPPER \"\$@\" >> /entrypoint.sh; chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

RUN /entrypoint.sh uname -a
