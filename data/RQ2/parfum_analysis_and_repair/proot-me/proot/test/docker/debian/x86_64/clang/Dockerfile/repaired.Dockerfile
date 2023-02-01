FROM proot-me/proot:alpine-x86_64

RUN apt install --no-install-recommends -y \
      clang \
      clang-tools-4.0 && rm -rf /var/lib/apt/lists/*;

