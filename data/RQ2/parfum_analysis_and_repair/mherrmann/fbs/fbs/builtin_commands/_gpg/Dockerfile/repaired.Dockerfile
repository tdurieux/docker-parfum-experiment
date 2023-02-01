FROM debian:9.6

ARG name
ARG email
ARG passphrase
ARG keylength=1024

RUN apt-get update && apt-get install --no-install-recommends gnupg2 pinentry-tty -y && rm -rf /var/lib/apt/lists/*; ADD gpg-agent.conf /root/.gnupg/gpg-agent.conf
RUN chmod -R 600 /root/.gnupg/


WORKDIR /root

ADD genkey.sh /root/genkey.sh
RUN chmod +x genkey.sh