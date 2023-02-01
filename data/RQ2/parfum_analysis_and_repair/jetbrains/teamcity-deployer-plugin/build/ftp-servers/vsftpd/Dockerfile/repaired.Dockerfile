FROM debian:11.2-slim

RUN apt update && apt install --no-install-recommends -y openssl vsftpd gpp && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /etc/vsftpd/
RUN useradd -ms /bin/bash guest && echo 'guest:guest' | chpasswd

COPY vsftp.gpp.conf /tmp
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh
RUN mkdir -p /home/vsftpd/
RUN chown -R ftp:ftp /home/vsftpd/

VOLUME /home/guest
VOLUME /var/log/vsftpd

EXPOSE 20 21 21100-21110

ENTRYPOINT ["/entrypoint.sh"]