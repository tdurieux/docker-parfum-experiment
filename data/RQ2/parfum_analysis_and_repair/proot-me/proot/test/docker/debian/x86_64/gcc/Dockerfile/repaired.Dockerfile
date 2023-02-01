FROM proot-me/proot:debian-x86_64

RUN apt install --no-install-recommends -y \
      gcc \
      gdb \
      lcov && rm -rf /var/lib/apt/lists/*;

