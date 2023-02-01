FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y mailutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y dovecot-pop3d && rm -rf /var/lib/apt/lists/*;
RUN useradd -m -d /home/jean -s /bin/bash jean
RUN echo 'jean:bon' | chpasswd
COPY main.cf /etc/postfix/main.cf
COPY mailname /etc/mailname
COPY jean.mail /var/mail/jean
COPY 10-auth.conf  /etc/dovecot/conf.d/10-auth.conf
RUN chown jean:mail /var/mail/jean
RUN chmod 600 /var/mail/jean
EXPOSE 25
EXPOSE 110
CMD ["sleep", "360"]