# Build GCC
COPY ["docker/android.sh", "/"]
RUN ARCH=^TOOLCHAIN^ /android.sh
RUN rm /android.sh

# Upgrade the CMake version.