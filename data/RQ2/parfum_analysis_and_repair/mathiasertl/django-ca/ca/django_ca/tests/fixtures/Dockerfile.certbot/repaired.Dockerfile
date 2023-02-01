ARG IMAGE=debian:bullseye
FROM $IMAGE

# NOTE: procps/bind9-hosts to help with debugging
RUN apt-get update && \
    apt-get install --no-install-recommends -y certbot curl dnsmasq inotify-tools && \
    apt-get install --no-install-recommends -y procps bind9-host && \
    rm -rf /var/lib/apt/lists/*
ADD ca/django_ca/tests/fixtures/cli.ini /etc/letsencrypt/cli.ini
ADD ca/django_ca/tests/fixtures/*.sh /usr/local/bin/
ADD ca/django_ca/tests/fixtures/django-ca-dns-auth.py /usr/local/bin/django-ca-dns-auth
ADD ca/django_ca/tests/fixtures/django-ca-dns-clean.py /usr/local/bin/django-ca-dns-clean

env DNSMASQ_CONF_DIR=/etc/dnsmasq.d/

WORKDIR /root/
ENTRYPOINT ["/usr/local/bin/dnsmasq.sh"]
CMD ["--log-queries"]
