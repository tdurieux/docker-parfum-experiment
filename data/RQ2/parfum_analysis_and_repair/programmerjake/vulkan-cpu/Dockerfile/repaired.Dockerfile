FROM ubuntu:xenial
RUN apt-get update -q && apt-get dist-upgrade -qy && apt-get install --no-install-recommends -qy clang-4.0 build-essential cmake ninja-build llvm-4.0-dev libsdl2-dev curl imagemagick && apt-get clean -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /build
COPY . /build
RUN ./docker-build-scripts/build.sh
RUN ./build/src/demo/demo > demo-output.txt 2>&1 && convert output.bmp output.png && curl -f -sS --upload-file ./output.png https://transfer.sh/output.png && echo && curl -f -sS --upload-file ./demo-output.txt https://transfer.sh/demo-output.txt && echo || echo running failed
CMD ["/bin/bash"]
