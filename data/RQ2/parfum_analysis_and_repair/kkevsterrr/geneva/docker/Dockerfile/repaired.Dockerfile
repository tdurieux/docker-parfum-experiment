FROM python:3.6-stretch
# Set the root password in the container so we can use it
RUN echo "root:Docker!" | chpasswd
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install libnetfilter-queue-dev iptables tcpdump netcat net-tools git graphviz openssh-server && rm -rf /var/lib/apt/lists/*;
# Enable root SSH login for client testing
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install tshark && rm -rf /var/lib/apt/lists/*;
ENV PATH="/usr/sbin:${PATH}"
RUN pip install --no-cache-dir netfilterqueue requests dnspython anytree graphviz netifaces paramiko tld docker scapy==2.4.3 psutil
ENTRYPOINT ["/bin/bash"]
