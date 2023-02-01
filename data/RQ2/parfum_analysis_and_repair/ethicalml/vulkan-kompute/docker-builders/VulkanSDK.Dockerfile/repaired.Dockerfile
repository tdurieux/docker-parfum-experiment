FROM amd64/ubuntu:20.04

ARG VULKAN_SDK_VERSION=1.2.154.0

# First install vulkan
RUN apt-get update
RUN apt-get install --no-install-recommends -y curl unzip tar wget && rm -rf /var/lib/apt/lists/*;
RUN wget -O VulkanSDK.tar.gz https://sdk.lunarg.com/sdk/download/${VULKAN_SDK_VERSION}/linux/vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.gz?u=true && \
    mkdir VulkanSDK && \
    cd VulkanSDK && \
    tar xvf /VulkanSDK.tar.gz && rm /VulkanSDK.tar.gz

RUN	cd VulkanSDK/${VULKAN_SDK_VERSION}
ENV	VULKAN_SDK="/VulkanSDK/${VULKAN_SDK_VERSION}/x86_64"
ENV	PATH="${VULKAN_SDK}/bin:${PATH}"
ENV	LD_LIBRARY_PATH="${VULKAN_SDK}/lib"
ENV	VK_LAYER_PATH="${VULKAN_SDK}/etc/explicit_layer.d"

# Configure dependencies required to setup external apt-repos
RUN apt-get install --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        gnupg \
        software-properties-common \
        wget -y && rm -rf /var/lib/apt/lists/*;

# Adding kitware repo to upgrade to latest cmake (17+)
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --batch --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
# Adding security repo to add cmake dependency on libssl 1.0
RUN echo "deb http://security.ubuntu.com/ubuntu bionic-security main" | tee -a /etc/apt/sources.list.d/bionic.list
RUN apt-get update --fix-missing -y
RUN apt-get upgrade -y

# Install build dependencies
RUN apt-get install --no-install-recommends -y libssl1.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libglm-dev libxcb-dri3-0 libxcb-present0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpciaccess0 libpng-dev libxcb-keysyms1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxcb-dri3-dev libx11-dev libmirclient-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libwayland-dev libxrandr-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libglfw3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y zip pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends xxd && rm -rf /var/lib/apt/lists/*;

RUN mkdir /core
WORKDIR /core
RUN git clone https://github.com/microsoft/vcpkg
RUN ./vcpkg/bootstrap-vcpkg.sh
ENV VCPKG_PATH=/core/vcpkg
ENV VCPKG_ROOT=/core/vcpkg

# INstall dependencies for kompute
RUN /core/vcpkg/vcpkg install fmt spdlog vulkan-headers gtest

RUN mkdir /workspace
WORKDIR /workspace

