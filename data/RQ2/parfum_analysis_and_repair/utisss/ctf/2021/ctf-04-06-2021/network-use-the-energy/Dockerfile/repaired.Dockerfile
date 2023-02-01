FROM ubuntu:latest

RUN apt update && apt install --no-install-recommends openssh-server sudo -y && rm -rf /var/lib/apt/lists/*;

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 mark

RUN  echo 'mark:princess1' | chpasswd

RUN service ssh start

EXPOSE 7822

COPY plans.txt /home/ubuntu

CMD ["/usr/sbin/sshd","-D"]
