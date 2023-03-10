FROM silex/emacs
MAINTAINER dickmao
RUN set -xe \
  && apt-get -yq update \
  && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -yq install gettext-base dovecot-common dovecot-imapd vim less netcat-openbsd sudo cron isync \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -ms /bin/bash doveuser \
  && sed -E -i 's|^(%sudo.*)ALL$|\1NOPASSWD: ALL|' /etc/sudoers \
  && usermod -aG sudo doveuser \
  && usermod -aG crontab doveuser
RUN --mount=type=secret,id=mysecret cat /run/secrets/mysecret > /tmp/.secret \
  && chown doveuser /tmp/.secret
COPY ${GMAIL_USER}.gpg /tmp/${GMAIL_USER}.gpg
COPY dot.authinfo /tmp/.authinfo
COPY dovecot.users /tmp/users
COPY dot.mbsyncrc /tmp/.mbsyncrc
COPY dot.msmtprc /tmp/.msmtprc
COPY dot.emacs /tmp/.emacs
COPY dot.gnus /tmp/.gnus
RUN set -xe \
  && DOVECOT_UID=$(id -u doveuser) DOVECOT_GID=$(id -g doveuser) DOVECOT_HOME=/home/doveuser envsubst < /tmp/users > /etc/dovecot/users \
  && chown root:dovecot /etc/dovecot/users \
  && chmod 640 /etc/dovecot/users \
  && sed -E -i 's|^#\s*(mail_debug).*|\1 = yes|' /etc/dovecot/conf.d/10-logging.conf \
  && sed -E -i 's|^#\s*(auth_debug).*|\1 = yes|' /etc/dovecot/conf.d/10-logging.conf \
  && sed -E -i 's|^#\s*(log_path).*|\1 = /var/log/dovecot.log|' /etc/dovecot/conf.d/10-logging.conf \
  && sed -E -i 's|^#\s*(!include auth-passwdfile.*)|\1|' /etc/dovecot/conf.d/10-auth.conf \
  && sed -E -i 's|^\s*(mail_location).*|\1 = maildir:%h/Maildir/%n:LAYOUT=fs:INBOX=%h/Maildir/%n/Inbox|' /etc/dovecot/conf.d/10-mail.conf \
  && touch /var/log/dovecot.log \
  && chmod 644 /var/log/dovecot.log
USER doveuser
ENV HOME=/home/doveuser
WORKDIR $HOME
RUN set -xe \
  && mkdir -p $HOME/Maildir/${GMAIL_USER} \
  && cp /tmp/${GMAIL_USER}.gpg $HOME/Maildir \
  && cp /tmp/.authinfo $HOME \
  && chmod 600 $HOME/.authinfo \
  && cp /tmp/.mbsyncrc $HOME \
  && cp /tmp/.msmtprc $HOME \
  && cp /tmp/.emacs $HOME \
  && cp /tmp/.gnus $HOME \
  && gpg --batch --allow-secret-key-import --import /tmp/.secret \
  && ${CI_SKIP_MBSYNC} \
  && printf -- "2,7,12,17,22,27,32,37,42,47,52,57 * * * * /usr/bin/mbsync -qq -a\n" | crontab -
CMD [ "sh", "-c", "sudo /usr/sbin/cron ; sudo /etc/init.d/dovecot start ; emacs -f gnus" ]
