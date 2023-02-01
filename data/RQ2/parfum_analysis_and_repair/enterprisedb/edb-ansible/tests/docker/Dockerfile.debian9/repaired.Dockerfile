FROM jrei/systemd-debian:9

RUN apt update
RUN apt install --no-install-recommends sudo -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends python3 -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends openssh-client -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends openssh-server -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends python3-apt -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends gpg -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends acl -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends apt-transport-https -y && rm -rf /var/lib/apt/lists/*;
RUN systemctl disable ssh
