FROM node:latest

RUN apt update && apt install --no-install-recommends openssh-server sudo net-tools -y && rm -rf /var/lib/apt/lists/*;

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 test

RUN  echo 'test:test' | chpasswd

RUN service ssh start
RUN ifconfig

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
CMD ["ifconfig"]