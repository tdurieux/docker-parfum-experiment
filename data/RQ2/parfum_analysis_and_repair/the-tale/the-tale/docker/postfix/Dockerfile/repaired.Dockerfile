FROM debian:bullseye-20211115

RUN apt-get update

RUN apt-get install --no-install-recommends -y locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3 python3-pip && \
    pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y rsyslog && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y postfix && rm -rf /var/lib/apt/lists/*;

ENV LANG="en_US.utf8" \
    PATH="$PATH:/postfix-bin"

COPY ./requirements.txt /root/requirements.txt

RUN pip3 install --no-cache-dir -r /root/requirements.txt

COPY ./templates /postfix-config-templates
COPY ./bin /postfix-bin

# on Debian postfix run in chroot by default and it brokes its behaviour
# so we turn of chroot
# problems described here:
# - https://serverfault.com/questions/655116/postfix-fails-to-send-mail-with-fatal-unknown-service-smtp-tcp
# - https://serverfault.com/questions/960456/postfix-name-service-error-for-name-domain-com-type-mx-host-not-found-try-aga
COPY ./master.cf /etc/postfix/master.cf

CMD ["postfix", "start-fg"]

ENTRYPOINT ["entrypoint.sh"]
