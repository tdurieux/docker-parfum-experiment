FROM ubuntu:20.04

ARG password
ARG username

RUN apt update && apt install --no-install-recommends openssh-server sudo -y && rm -rf /var/lib/apt/lists/*;

RUN useradd -rm -d /home/${username} -s /bin/bash -g root -G sudo -u 1000 ${username}

RUN echo ${username}:${password} | chpasswd

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
