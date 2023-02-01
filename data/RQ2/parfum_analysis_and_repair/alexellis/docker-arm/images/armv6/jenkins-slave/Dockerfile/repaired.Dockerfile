FROM resin/rpi-raspbian

RUN apt-get update
RUN apt-get install -y --no-install-recommends openjdk-7-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends ca-certificates \
  openssh-server openssl && rm -rf /var/lib/apt/lists/*;

RUN ssh-keygen -A

RUN addgroup jenkins && \
    useradd jenkins -m -g jenkins --shell /bin/bash && \
    chown -R jenkins:jenkins /home/jenkins && \
    echo "jenkins:jenkins" | chpasswd

RUN set -x && \
    echo "UsePrivilegeSeparation no" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "AllowGroups jenkins" >> /etc/ssh/sshd_config

RUN    echo "%jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir -p  /var/run/sshd

FROM resin/rpi-raspbian

RUN apt-get update
RUN apt-get install -y --no-install-recommends openjdk-7-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends ca-certificates \
  openssh-server openssl && rm -rf /var/lib/apt/lists/*;

RUN ssh-keygen -A

RUN addgroup jenkins && \
    useradd jenkins -m -g jenkins --shell /bin/bash && \
    chown -R jenkins:jenkins /home/jenkins && \
    echo "jenkins:jenkins" | chpasswd

RUN set -x && \
    echo "UsePrivilegeSeparation no" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "AllowGroups jenkins" >> /etc/ssh/sshd_config

RUN    echo "%jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir -p  /var/run/sshd

RUN apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends curl wget && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s \
https://packagecloud.io/install/repositories/Hypriot/Schatzkiste/script.deb.sh | sudo bash
RUN sudo apt-get install -y --no-install-recommends docker-hypriot=1.11.1-1 && rm -rf /var/lib/apt/lists/*;
RUN usermod jenkins -aG docker

RUN apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;

EXPOSE 22
USER jenkins
WORKDIR /home/jenkins/
ADD ./init.sh ./init.sh

CMD ["./init.sh"]
