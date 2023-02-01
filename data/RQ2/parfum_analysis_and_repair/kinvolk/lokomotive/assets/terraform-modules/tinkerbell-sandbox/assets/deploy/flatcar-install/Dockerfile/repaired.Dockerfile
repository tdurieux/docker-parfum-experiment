FROM ubuntu

RUN apt update && \
		apt install --no-install-recommends -y udev gpg wget btrfs-progs gawk && rm -rf /var/lib/apt/lists/*;

RUN wget https://raw.githubusercontent.com/flatcar-linux/init/flatcar-master/bin/flatcar-install -O /usr/local/bin/flatcar-install && \
    chmod +x /usr/local/bin/flatcar-install
