FROM ubuntu:bionic
# Docker build arguments
ARG SOURCE_DIR=/jellyfin
ARG ARTIFACT_DIR=/dist
# Docker run environment
ENV SOURCE_DIR=/jellyfin
ENV ARTIFACT_DIR=/dist
ENV DEB_BUILD_OPTIONS=noddebs
ENV ARCH=amd64
ENV IS_DOCKER=YES

# Prepare Debian build environment
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    apt-transport-https debhelper gnupg wget ca-certificates devscripts \
    mmv build-essential libcurl4-openssl-dev libfontconfig1-dev \
    libfreetype6-dev libssl-dev libssl1.1 liblttng-ust0 && rm -rf /var/lib/apt/lists/*;

# Install dotnet repository
RUN wget -q https://download.visualstudio.microsoft.com/download/pr/77d472e5-194c-421e-992d-e4ca1d08e6cc/56c61ac303ddf1b12026151f4f000a2b/dotnet-sdk-6.0.301-linux-x64.tar.gz -O dotnet-sdk.tar.gz \
  && mkdir -p dotnet-sdk \
  && tar -xzf dotnet-sdk.tar.gz -C dotnet-sdk \
  && ln -s $( pwd )/dotnet-sdk/dotnet /usr/bin/dotnet && rm dotnet-sdk.tar.gz

# Link to build script
RUN ln -sf ${SOURCE_DIR}/deployment/build.ubuntu.amd64 /build.sh

VOLUME ${SOURCE_DIR}/

VOLUME ${ARTIFACT_DIR}/

ENTRYPOINT ["/build.sh"]
