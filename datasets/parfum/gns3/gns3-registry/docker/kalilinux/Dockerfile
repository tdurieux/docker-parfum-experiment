FROM kalilinux/kali-rolling

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y tshark && apt-get install -y --no-install-recommends metasploit-framework nmap hydra sqlmap telnet openssh-client dnsutils yersinia ettercap-text-only cisco-global-exploiter cisco-auditing-tool snmp dsniff dnschef fping hping3 python-scapy\
    && rm -rf /var/lib/apt/lists/*

CMD /bin/bash 
