FROM quay.io/pypa/manylinux_2_24_x86_64

LABEL maintainer "Datoviz Development Team"

# Install the build and lib dependencies, install vulkan and a recent version of CMake
RUN \
    apt-get update && \
    apt install --no-install-recommends -y wget libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev \
    libxcursor-dev ninja-build && rm -rf /var/lib/apt/lists/*;

# install vulkan sdk
ENV VULKAN_SDK_VERSION=1.2.170.0
RUN echo "downloading Vulkan SDK $VULKAN_SDK_VERSION" \
    && wget -q --show-progress --progress=bar:force:noscroll \
    "https://sdk.lunarg.com/sdk/download/$VULKAN_SDK_VERSION/linux/vulkansdk-linux-x86_64-$VULKAN_SDK_VERSION.tar.gz?Human=true" \
    -O /tmp/vulkansdk-linux-x86_64-$VULKAN_SDK_VERSION.tar.gz \
    && echo "installing Vulkan SDK $VULKAN_SDK_VERSION" \
    && mkdir -p /opt/vulkan \
    && tar -xf /tmp/vulkansdk-linux-x86_64-$VULKAN_SDK_VERSION.tar.gz -C /opt/vulkan \
    &&  rm /tmp/vulkansdk-linux-x86_64-$VULKAN_SDK_VERSION.tar.gz
ENV VULKAN_SDK=/opt/vulkan/${VULKAN_SDK_VERSION}/x86_64
ENV PATH="$VULKAN_SDK/bin:$PATH" \
    LD_LIBRARY_PATH="$VULKAN_SDK/lib:${LD_LIBRARY_PATH:-}" \
    VK_LAYER_PATH="$VULKAN_SDK/etc/vulkan/explicit_layer.d"

# Use a given version of Python (todo: support other version of Python).
ENV PYTHON='/opt/python/cp38-cp38/bin/python3' \
    PIP='/opt/python/cp38-cp38/bin/pip'

# Install the patched version of auditwheel to include just specific libraries in the wheel.
RUN $PYTHON -m pip install --upgrade pip
RUN $PIP uninstall auditwheel
RUN $PIP install git+https://github.com/rossant/auditwheel.git@include-exclude --user

ENV AUDITWHEEL='/root/.local/bin/auditwheel'

# Install build Python dependencies.
RUN $PIP install \
    bokeh \
    colorcet \
    cython \
    ghp-import \
    imageio \
    matplotlib \
    mkdocs \
    mkdocs-material \
    mkdocs-material-extensions \
    mkdocs-simple-hooks \
    numpy \
    pillow \
    pyparsing \
    tqdm \
    twine
