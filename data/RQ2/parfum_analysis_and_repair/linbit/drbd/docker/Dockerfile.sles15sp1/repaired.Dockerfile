FROM opensuse/leap:15.1

RUN zypper install -y tar gzip wget gcc make patch curl kmod cpio python3 python3-pip && zypper clean --all && \
	pip3 install --no-cache-dir https://github.com/LINBIT/python-lbdist/archive/master.tar.gz

COPY /drbd.tar.gz /

COPY /pkgs /pkgs

COPY /entry.sh /
RUN chmod +x /entry.sh
ENTRYPOINT /entry.sh
