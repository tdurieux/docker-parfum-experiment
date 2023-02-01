# Baseimage Debin
FROM debian

# Install clang, cmake, ninja
RUN apt-get update && apt-get install --no-install-recommends -y clang gdb lldb cmake ninja-build && rm -rf /var/lib/apt/lists/*;

