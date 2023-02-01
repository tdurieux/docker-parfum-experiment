ARG PLATFORM=android-23
ARG TOOLCHAIN=arm-linux-androideabi-4.9

FROM rhardih/stand:r18b--$PLATFORM--$TOOLCHAIN

ARG PLATFORM
ENV PLATFORM $PLATFORM
ARG HOST=arm-linux-androideabi

# List of available versions can be found at
# https://github.com/OSGeo/proj.4/releases
ARG VERSION

RUN apt-get update && apt-get -y --no-install-recommends install \
  wget && rm -rf /var/lib/apt/lists/*;

RUN wget -O proj-$VERSION.tar.gz \
  https://download.osgeo.org/proj/proj-$VERSION.tar.gz && \
  tar -xzvf proj-$VERSION.tar.gz && \
  rm proj-$VERSION.tar.gz

WORKDIR /proj-$VERSION

ENV PATH $PATH:/$PLATFORM-toolchain/bin

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --host=$HOST \
  --prefix=/proj-build/

RUN make -j && make install
