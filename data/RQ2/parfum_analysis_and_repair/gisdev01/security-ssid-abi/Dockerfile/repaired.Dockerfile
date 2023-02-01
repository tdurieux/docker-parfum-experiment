FROM kalilinux/kali-linux-docker
RUN apt clean all && apt update && apt upgrade -y
RUN apt install --no-install-recommends -y aircrack-ng pciutils && rm -rf /var/lib/apt/lists/*;
RUN apt autoremove -y && apt clean all
