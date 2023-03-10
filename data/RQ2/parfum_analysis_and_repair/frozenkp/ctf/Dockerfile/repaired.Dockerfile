# This is a dockerfile for pwn environment.
# Last update: 2018/05/01
# version 1.0.8

# Run command:
# docker run -it {--name pwn_env} {-v /??/data:/root/data} --privileged frozenkp/pwn /bin/bash

FROM ubuntu

MAINTAINER frozenkp

WORKDIR /root

RUN dpkg --add-architecture i386 ; apt-get update ; apt-get install --no-install-recommends -y git tmux gdb vim binutils python python-pip python-dev libssl-dev libffi-dev build-essential rubygems netcat nmap libc6:i386 libncurses5:i386 libstdc++6:i386 python-capstone && rm -rf /var/lib/apt/lists/*;

# pwntools
RUN pip install --no-cache-dir --upgrade pip; pip install --no-cache-dir --upgrade pwntools

# pwngdb
RUN git clone https://github.com/scwuaptx/Pwngdb.git ; cp ~/Pwngdb/.gdbinit ~/

# peda
# original
# RUN git clone https://github.com/longld/peda.git ~/peda ; echo "source ~/peda/peda.py" >> ~/.gdbinit
# angelboy-peda
RUN git clone https://github.com/scwuaptx/peda.git ~/peda ; echo "source ~/peda/peda.py" >> ~/.gdbinit ; cp ~/peda/.inputrc ~/

# onegadget
RUN gem install one_gadget

# radare2
RUN git clone https://github.com/radare/radare2.git ; radare2/sys/install.sh
