FROM	ubuntu:18.04


RUN apt update && apt install --no-install-recommends -y build-essential gcc-arm-none-eabi clang llvm git python-pip && rm -rf /var/lib/apt/lists/*;
RUN mkdir build
WORKDIR /build
CMD ["./ci_build.sh"]