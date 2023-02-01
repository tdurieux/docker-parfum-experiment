FROM debian
RUN apt-get -y update && apt-get -y --no-install-recommends install gettext stunnel && rm -rf /var/lib/apt/lists/*;
ADD stunnel.sh /usr/local/bin/
ADD stunnel.conf.template /etc/stunnel/
ENTRYPOINT ["/usr/local/bin/stunnel.sh"]
