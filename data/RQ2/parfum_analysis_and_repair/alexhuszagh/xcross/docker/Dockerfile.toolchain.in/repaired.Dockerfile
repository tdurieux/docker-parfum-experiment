# Add toolchains
COPY ["cmake/toolchain/^TARGET^.cmake", "/toolchains/toolchain.cmake"]
# This step is mostly for backward compatibility.