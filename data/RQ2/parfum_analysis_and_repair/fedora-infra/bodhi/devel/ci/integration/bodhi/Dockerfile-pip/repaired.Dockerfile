FROM bodhi-ci/pip
LABEL \
  name="bodhi-web" \
  vendor="Fedora Infrastructure" \
  maintainer="Aurelien Bompard <abompard@fedoraproject.org>" \
  license="MIT"
ENV VIRTUAL_ENV=/srv/venv
# For integration testing we're using the infrastructure repo
RUN curl -f -o /etc/yum.repos.d/infra-tags.repo https://pagure.io/fedora-infra/ansible/raw/main/f/files/common/fedora-infra-tags.repo

# Install Bodhi deps (that were not needed by the unittests container)
RUN dnf install -y \
    httpd \
    intltool \
    python3-koji \
    /usr/bin/koji \
    python3-mod_wsgi \
    python3-pip \
    python3-dnf \
    skopeo

# Mimic RPM's handling of Python3-specific binaries
RUN ln -s alembic /usr/local/bin/alembic-3
RUN ln -s celery /usr/local/bin/celery-3

# Create bodhi user
RUN groupadd -r bodhi && \
    useradd  -r -s /sbin/nologin -d /home/bodhi/ -m -c 'Bodhi Server' -g bodhi bodhi
# Install it
RUN \
    for pkg in bodhi-client bodhi-messages bodhi-server; do \
        cd $pkg && \
        pip3 install --no-cache-dir . && \
        cd -; \
    done

# Because we use self-signed certificates in integration tests
RUN pip3 install --no-cache-dir certifi

# Configuration
RUN mkdir -p /etc/bodhi
COPY devel/ci/integration/bodhi/production.ini /etc/bodhi/production.ini
COPY devel/ci/integration/bodhi/celeryconfig.py /etc/bodhi/celeryconfig.py
# Client authentication
RUN mkdir -p /home/bodhi/.config/bodhi/
COPY devel/ci/integration/bodhi/client.json /home/bodhi/.config/bodhi/
RUN chown bodhi:bodhi -R /home/bodhi/.config/

COPY devel/ci/integration/bodhi/start.sh /etc/bodhi/start.sh
COPY devel/ci/integration/bodhi/fedora-messaging.toml /etc/fedora-messaging/config.toml
COPY devel/ci/integration/bodhi/httpd.conf /etc/bodhi/httpd.conf
COPY bodhi-server/apache/bodhi.wsgi /etc/bodhi/bodhi.wsgi
RUN sed -i -e 's,/var/www,/httpdir,g' /etc/bodhi/bodhi.wsgi
COPY devel/ci/integration/bodhi/fedora-messaging.toml /etc/fedora-messaging/config.toml
# workaround for https://github.com/moby/moby/issues/37965
RUN true
# Composes
COPY devel/ci/integration/bodhi/pungi-call-dump.sh /etc/bodhi/pungi-call-dump.sh
COPY devel/ci/integration/bodhi/pungi.rpm.conf.j2 /etc/bodhi/pungi.rpm.conf.j2
COPY devel/ci/integration/bodhi/pungi.module.conf.j2 /etc/bodhi/pungi.module.conf.j2
COPY devel/ci/integration/bodhi/variants.rpm.xml.j2 /etc/bodhi/variants.rpm.xml.j2
COPY devel/ci/integration/bodhi/variants.module.xml.j2 /etc/bodhi/variants.module.xml.j2

RUN \
# Set up krb5
    rm -f /etc/krb5.conf && \
    ln -sf /etc/bodhi/krb5.conf /etc/krb5.conf && \
    ln -sf /etc/keytabs/koji-keytab /etc/krb5.bodhi_bodhi.fedoraproject.org.keytab

# Apache
RUN mkdir -p /httpdir && chown bodhi:bodhi /httpdir

# Tests tooling
COPY devel/ci/integration/bodhi/wait-for-file.py /usr/local/bin/wait-for-file
RUN chmod +x /usr/local/bin/wait-for-file
# Celery results
RUN mkdir -p /srv/celery-results && chown -R bodhi:bodhi /srv/celery-results
# Composes
RUN mkdir -p /srv/composes/final /srv/composes/stage && chown -R bodhi:bodhi /srv/composes

EXPOSE 8080
USER bodhi
ENV USER=bodhi
CMD ["bash", "/etc/bodhi/start.sh"]
