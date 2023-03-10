FROM ubuntu:latest

ENV JAVA_HOME=/opt/jdk
ENV PATH=$PATH:/opt/jdk/bin
ARG DEBIAN_FRONTEND=noninteractive

# Install various dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
		ffmpeg \
		maven \
		wget \
  		libopenjp2-tools \
                liblcms2-dev \
                libpng-dev \
                libzstd-dev \
                libtiff-dev \
                libjpeg-dev \
                zlib1g-dev \
                libwebp-dev \
                libimage-exiftool-perl \
    && rm -rf /var/lib/apt/lists/*

# Install TurboJpegProcessor dependencies
RUN mkdir -p /opt/libjpeg-turbo/lib
COPY docker/Linux-JDK11/image_files/libjpeg-turbo/lib64 /opt/libjpeg-turbo/lib

# Install KakaduNativeProcessor dependencies
COPY dist/deps/Linux-x86-64/lib/* /usr/lib/

# Install GrokProcessor dependencies
RUN wget -q https://github.com/GrokImageCompression/grok/releases/download/v7.6.5/libgrokj2k1_7.6.5-1_amd64.deb \
    && wget -q https://github.com/GrokImageCompression/grok/releases/download/v7.6.5/grokj2k-tools_7.6.5-1_amd64.deb \
    && dpkg -i ./libgrokj2k1_7.6.5-1_amd64.deb \
    && dpkg -i --ignore-depends=libjpeg62-turbo ./grokj2k-tools_7.6.5-1_amd64.deb

# Install OpenJDK
RUN wget -q https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15.0.1%2B9/OpenJDK15U-jdk_x64_linux_hotspot_15.0.1_9.tar.gz \
    && tar xfz OpenJDK15U-jdk_x64_linux_hotspot_15.0.1_9.tar.gz \
    && mv jdk-15.0.1+9 /opt/jdk && rm OpenJDK15U-jdk_x64_linux_hotspot_15.0.1_9.tar.gz

# A non-root user is needed for some FilesystemSourceTest tests to work.
ARG user=cantaloupe
ARG home=/home/$user
RUN adduser --home $home $user
RUN chown -R $user $home
USER $user
WORKDIR $home

# Install application dependencies
COPY ./pom.xml pom.xml
RUN mvn --quiet dependency:resolve

# Copy the code
COPY --chown=cantaloupe docker/Linux-JDK11/image_files/test.properties test.properties
COPY --chown=cantaloupe ./src src

ENTRYPOINT mvn --batch-mode test -Pfreedeps