FROM kalilinux/kali-rolling

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y git ipcalc curl dnsutils ncat && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/trustedsec/hardcidr

WORKDIR hardcidr

ENTRYPOINT [ "bash" ]