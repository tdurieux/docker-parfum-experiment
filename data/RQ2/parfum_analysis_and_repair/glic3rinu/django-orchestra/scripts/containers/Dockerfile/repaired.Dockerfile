FROM debian:latest

RUN apt-get -y update && apt-get install --no-install-recommends -y curl sudo && rm -rf /var/lib/apt/lists/*;

RUN export TERM=xterm; curl -f -L https://git.io/orchestra-admin | bash -s install_requirements

RUN apt-get clean

RUN useradd orchestra --shell /bin/bash && \
    { echo "orchestra:orchestra" | chpasswd; } && \
    mkhomedir_helper orchestra && \
    adduser orchestra sudo
