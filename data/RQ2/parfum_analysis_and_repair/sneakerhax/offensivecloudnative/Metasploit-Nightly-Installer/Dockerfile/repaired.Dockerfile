FROM ubuntu:latest

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y curl gnupg nmap && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall
RUN useradd -ms /bin/bash msf
COPY msfstart.sh .
RUN chmod +x msfstart.sh
ENTRYPOINT [ "bash", "./msfstart.sh" ]
