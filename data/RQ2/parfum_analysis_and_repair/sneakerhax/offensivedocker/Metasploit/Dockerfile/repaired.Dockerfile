FROM kalilinux/kali-rolling

RUN apt update && apt -y upgrade
RUN apt install --no-install-recommends -y metasploit-framework && rm -rf /var/lib/apt/lists/*;
COPY msfstart.sh .
RUN chmod +x msfstart.sh
ENTRYPOINT [ "bash", "./msfstart.sh" ]