FROM arm64v8/debian:bullseye
MAINTAINER russ@russross.com

RUN apt update && apt upgrade -y

RUN apt install -y --no-install-recommends \
    make \
    python3 && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends \
    binutils-riscv64-unknown-elf \
    gcc-riscv64-unknown-elf \
    qemu-user && rm -rf /var/lib/apt/lists/*;

RUN mkdir /home/student && chmod 777 /home/student
USER 2000
WORKDIR /home/student
