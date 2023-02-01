# Origin image
FROM ubuntu:16.04

# update
RUN sed -i -re 's/http:\/\/(archive.ubuntu.com|security.ubuntu.com|extras.ubuntu.com)/http:\/\/mirror.kakao.com/g' /etc/apt/sources.list

RUN apt update -y && apt install --no-install-recommends -y \
    libsqlite3-dev \
    socat \
    gdb && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade -y

# Setup Server Environment





# add new user if it is needed
RUN useradd -d /home/ctf/ -m -p ctf -s /bin/bash ctf
RUN echo "ctf:ctf" | chpasswd

# Change work directory
WORKDIR /home/ctf


RUN chmod 555 /home/ctf
RUN chmod 770 /tmp

# Change user
USER ctf

# Entry point
ENTRYPOINT socat tcp-l:5555,fork,reuseaddr exec:./client && /bin/bash
