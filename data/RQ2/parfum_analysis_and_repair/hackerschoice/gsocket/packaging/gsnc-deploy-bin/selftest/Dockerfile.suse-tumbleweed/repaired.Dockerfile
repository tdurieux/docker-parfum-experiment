FROM opensuse/tumbleweed

RUN zypper install -y wget tar gzip && \
	zypper clean -a && \
	echo done