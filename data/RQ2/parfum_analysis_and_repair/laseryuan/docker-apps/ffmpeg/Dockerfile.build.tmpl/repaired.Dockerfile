FROM {{ARCH.images.base}}

ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib

# Install builder dependency
RUN apt-get update -qy && apt-get install --no-install-recommends -qy \
      build-essential curl && rm -rf /var/lib/apt/lists/*;

{{#ARCH.is_arm}}
RUN apt-get update -qy && apt-get install --no-install-recommends -qy \
      libraspberrypi-doc libraspberrypi-dev raspberrypi-kernel-headers \
      libomxil-bellagio-dev && rm -rf /var/lib/apt/lists/*;
{{/ARCH.is_arm}}

# Install fdk-aac
{{#ARCH.is_arm}}
ENV FDK_AAC_PACKAGE="http://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.6.tar.gz"
RUN curl -f -L ${FDK_AAC_PACKAGE} -o /tmp/fdk-aac.tar.gz && \
    tar xvf /tmp/fdk-aac.tar.gz -C /tmp/ && \
    mv /tmp/fdk-aac-0.1.6 /tmp/fdk-aac && rm /tmp/fdk-aac.tar.gz

WORKDIR /tmp/fdk-aac
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j4 && \
    make install
{{/ARCH.is_arm}}

{{#ARCH.is_amd}}
RUN echo "deb http://http.debian.net/debian/ stretch main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://http.debian.net/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && apt-get install --no-install-recommends -qy \
      libfdk-aac-dev yasm && rm -rf /var/lib/apt/lists/*;
{{/ARCH.is_amd}}
