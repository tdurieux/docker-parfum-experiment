FROM centos:7
# Docker build arguments
ARG SOURCE_DIR=/jellyfin
ARG ARTIFACT_DIR=/dist
# Docker run environment
ENV SOURCE_DIR=/jellyfin
ENV ARTIFACT_DIR=/dist
ENV IS_DOCKER=YES

# Prepare CentOS environment
RUN yum update -yq \
  && yum install -yq epel-release \
  && yum install -yq @buildsys-build rpmdevtools yum-plugins-core libcurl-devel fontconfig-devel freetype-devel openssl-devel glibc-devel libicu-devel git wget && rm -rf /var/cache/yum

# Install DotNET SDK
RUN wget -q https://download.visualstudio.microsoft.com/download/pr/77d472e5-194c-421e-992d-e4ca1d08e6cc/56c61ac303ddf1b12026151f4f000a2b/dotnet-sdk-6.0.301-linux-x64.tar.gz -O dotnet-sdk.tar.gz \
  && mkdir -p dotnet-sdk \
  && tar -xzf dotnet-sdk.tar.gz -C dotnet-sdk \
  && ln -s $( pwd )/dotnet-sdk/dotnet /usr/bin/dotnet && rm dotnet-sdk.tar.gz

# Create symlinks and directories
RUN ln -sf ${SOURCE_DIR}/deployment/build.centos.amd64 /build.sh \
  && mkdir -p ${SOURCE_DIR}/SPECS \
  && ln -s ${SOURCE_DIR}/fedora/jellyfin.spec ${SOURCE_DIR}/SPECS/jellyfin.spec \
  && mkdir -p ${SOURCE_DIR}/SOURCES \
  && ln -s ${SOURCE_DIR}/fedora ${SOURCE_DIR}/SOURCES

VOLUME ${SOURCE_DIR}/

VOLUME ${ARTIFACT_DIR}/

ENTRYPOINT ["/build.sh"]
