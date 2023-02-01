FROM conanio/clang9 AS amqpprox_build_environment
RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y llvm && rm -rf /var/lib/apt/lists/*;
WORKDIR /source
ENV BUILDDIR=/build
ENV CONAN_USER_HOME=/build
