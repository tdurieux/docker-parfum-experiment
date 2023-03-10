# Conjur Base Image (UBI)
FROM cyberark/ubi-ruby-fips:latest

EXPOSE 8080
ARG VERSION

ENV PORT=8080 \
    LOG_DIR=/opt/conjur-server/log \
    TMP_DIR=/opt/conjur-server/tmp \
    SSL_CERT_DIRECTORY=/opt/conjur/etc/ssl \
    RAILS_ENV=production

LABEL name="conjur-ubi" \
      vendor="CyberArk" \
      version="$VERSION" \
      release="$VERSION" \
      summary="Conjur UBI-based image" \
      description="Conjur provides secrets management and machine identity for modern infrastructure."

RUN INSTALL_PKGS="gcc \
                  gcc-c++ \
                  git \
                  glibc-devel \
                  libxml2-devel \
                  libxslt-devel \
                  make \
                  openldap-clients \
                  tzdata" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && rm -rf /var/cache/yum

# Create conjur user with one that has known gid / uid.
RUN groupadd -r conjur \
             -g 777 && \
    useradd -c "conjur runner account" \
            -g conjur \
            -d "$HOME" \
            -r \
            -m \
            -s /bin/bash \
            -u 777 conjur

WORKDIR /opt/conjur-server

# Ensure few required GID0-owned folders to run as a random UID (OpenShift requirement)
RUN mkdir -p "$TMP_DIR" \
             "$LOG_DIR" \
             "$SSL_CERT_DIRECTORY/ca" \
             "$SSL_CERT_DIRECTORY/cert" \
             /run/authn-local && \
    # Use GID of 0 since that is what OpenShift will want to be able to read things
    chown conjur:0 "$LOG_DIR" \
                   "$TMP_DIR" \
                   "$SSL_CERT_DIRECTORY" \
                   /run/authn-local && \
    # We need open group permissions in these directories since OpenShift won't
    # match our UID when we try to write files to them
    chmod 770 "$LOG_DIR" \
              "$TMP_DIR" \
              "$SSL_CERT_DIRECTORY" \
              /run/authn-local

COPY Gemfile \
     Gemfile.lock ./
COPY gems/ gems/


RUN bundle --without test development

COPY . .

# removing CA bundle of httpclient gem
RUN find / -name httpclient -type d -exec find {} -name *.pem -type f -delete \;

RUN ln -sf /opt/conjur-server/bin/conjurctl /usr/local/bin/

COPY LICENSE.md /licenses/

USER conjur

ENTRYPOINT ["conjurctl"]
