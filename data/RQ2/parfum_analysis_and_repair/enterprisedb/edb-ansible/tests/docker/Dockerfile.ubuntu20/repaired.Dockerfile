FROM jrei/systemd-ubuntu:20.04

RUN apt update
RUN apt install --no-install-recommends iproute2 -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends sudo -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends python3 -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends openssh-client -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends openssh-server -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends python3-apt -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends gpg -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends acl -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends apt-transport-https -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends iputils-ping -y && rm -rf /var/lib/apt/lists/*;
RUN systemctl disable ssh
