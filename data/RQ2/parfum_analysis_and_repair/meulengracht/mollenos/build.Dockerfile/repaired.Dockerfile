# Now we setup the environment for using the cross-compiler
FROM valios/vali-toolchain:v1.9

# Build configuration arguments
# CROSS_PATH must match what is set in the toolchain image
ARG CROSS_PATH=/usr/workspace/toolchain-out
ARG ARCH

# Setup required environmental variables
ENV CROSS=$CROSS_PATH
ENV VALI_INSTALL_DIR=/usr/workspace
ENV VALI_ARCH=$ARCH
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.dotnet:${PATH}"

# Set the directory
WORKDIR /usr/workspace/vali

# Copy all repository files to image
COPY . .

# Build the operating system