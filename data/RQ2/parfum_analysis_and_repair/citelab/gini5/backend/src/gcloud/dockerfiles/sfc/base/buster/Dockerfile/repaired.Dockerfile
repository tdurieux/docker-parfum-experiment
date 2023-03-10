FROM debian:latest

LABEL maintainer="trung.vuongthien@mail.mcgill.ca"

RUN apt update && apt install --no-install-recommends -y \
        curl \
        iptables \
        ebtables \
        tcpdump \
	man \
	nmap \
	iproute2 \
	net-tools \
	nftables \
	iperf \
	tshark \
	dsniff \
	openssh-server \
	lynx \
	hping3 && rm -rf /var/lib/apt/lists/*;


RUN mkdir /book_files && mkdir /book_files/iptables && mkdir /book_files/hping
COPY ruleset_1C.sh /book_files/iptables/ruleset_1C.sh
COPY ruleset_1S.sh /book_files/iptables/ruleset_1S.sh
COPY hping_ex.sh /book_files/hping/hping_ex.sh

CMD ["/bin/sh"]

