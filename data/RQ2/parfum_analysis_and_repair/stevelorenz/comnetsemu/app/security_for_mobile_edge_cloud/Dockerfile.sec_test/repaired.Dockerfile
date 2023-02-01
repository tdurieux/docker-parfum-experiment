#
# About: Test image for development
#

FROM ubuntu:18.04

RUN \
        apt-get update --fix-missing && \
        apt-get -y upgrade && \
        apt-get install --no-install-recommends -y build-essential && \
        apt-get install --no-install-recommends -y net-tools iproute2 iputils-ping \
        apt-transport-https ca-certificates curl stress nmap iperf iperf3 telnet netcat openssh-server nano vim && rm -rf /var/lib/apt/lists/*;

# Install Docker from Docker Inc. repositories.
RUN curl -f -sSL https://get.docker.com/ | sh

# Install wireguard
RUN apt-get install --no-install-recommends -y software-properties-common && \
	add-apt-repository -y ppa:wireguard/wireguard && \
	apt-get update && \
	apt-get install --no-install-recommends -y wireguard && rm -rf /var/lib/apt/lists/*;

# Install nftables
RUN apt-get update && \
	apt-get install --no-install-recommends -y nftables && rm -rf /var/lib/apt/lists/*;

# Install network sniffing and ftp server
RUN apt-get update && \
		apt-get install --no-install-recommends -y tcpdump ftp vsftpd dsniff && rm -rf /var/lib/apt/lists/*;

ENV HOME /root
WORKDIR /root

# Define default command.
CMD ["bash"]
