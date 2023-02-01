FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y build-essential cmake vim gdb strace psmisc pkg-config python3 python3-pip git sed && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/bash"]

