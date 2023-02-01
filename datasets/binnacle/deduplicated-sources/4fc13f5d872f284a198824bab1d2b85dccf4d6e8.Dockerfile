FROM debian:jessie-slim
EXPOSE 8389

LABEL maintainer "infrastructure@orangebus.co.uk"

ENV LDAP_PORT=8389 \
    LDAP_BASE_DN="dc=nodomain" \
    LDAP_PASSWORD="@auth_ldap_password@" \
    LDAP_ENCRYPTION_KEY="@auth_ldap_encryption_key@" \
    LDAP_ENCRYPTION_CERTIFICATE="@auth_ldap_encryption_certificate@" \
    DEBIAN_FRONTEND=noninteractive

COPY scripts/* /usr/local/bin/
WORKDIR /usr/local/bin

RUN apt-get update --fix-missing && \

# preconfigure openldap \
  echo "slapd slapd/password1 password $LDAP_PASSWORD" | debconf-set-selections && \
  echo "slapd slapd/password2 password $LDAP_PASSWORD" | debconf-set-selections && \
  echo "slapd slapd/internal/adminpw password $LDAP_PASSWORD" | debconf-set-selections && \
  echo "slapd slapd/internal/generated_adminpw password $LDAP_PASSWORD" | debconf-set-selections && \

# install openldap \
  apt-get -y install slapd ldap-utils && \
  apt-get autoclean && apt-get --purge -y autoremove && rm -rf /var/lib/apt/lists/* && \

  /usr/sbin/slapd -h "ldapi:///" -g openldap -u openldap -F /etc/ldap/slapd.d && \
  sleep 3 && \
# configure password policy \
  ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/ppolicy.ldif && \
  ldapadd -Y EXTERNAL -H ldapi:/// -f ppolicymod.ldif && \
  ldapadd -Y EXTERNAL -H ldapi:/// -f ppolicy.ldif && \
  ldapadd -H ldapi:/// -f ppolicy_ou.ldif -D cn=admin,$LDAP_BASE_DN -w $LDAP_PASSWORD && \
  ldapadd -H ldapi:/// -f ppolicy_cn.ldif -D cn=admin,$LDAP_BASE_DN -w $LDAP_PASSWORD && \
  ldapmodify -H ldapi:/// -f ppolicy_cn_attribs.ldif -D cn=admin,$LDAP_BASE_DN -w $LDAP_PASSWORD && \
# enable & enforce SSL, be lax about self-signed certificates \
  echo "$LDAP_ENCRYPTION_KEY" > /etc/ldap/ldap-encryption.key && \
  echo "$LDAP_ENCRYPTION_CERTIFICATE" > /etc/ldap/ldap-encryption.crt && \
  ldapmodify -Y EXTERNAL -H ldapi:/// -f mod_ssl.ldif && \
  sed -i 's#/etc/ssl/certs/ca-certificates.crt#/etc/ldap/ldap-encryption.crt##' /etc/ldap/ldap.conf && \
  echo "TLS_REQCERT allow" >> /etc/ldap/ldap.conf && \
# allow unlimited search results \
  ldapmodify -Y EXTERNAL -H ldapi:/// -f mod_search_limit.ldif && \
# allow unlimited search results -frontend \
  ldapmodify -Y EXTERNAL -H ldapi:/// -f mod_search_limit_frontend.ldif && \

# run openldap as its own user \
  ldapmodify -Y EXTERNAL -H ldapi:/// -f openldap_user_access.ldif && \
  chown -R openldap:0 /etc/ldap /var/lib/ldap /var/run/slapd && \
  chmod -R g+rw /etc/ldap /var/lib/ldap /var/run/slapd

# install dev tools and test ldap entries \
RUN apt-get update --fix-missing && \
  apt-get -y install grep mysql-client net-tools rsync && \
  apt-get autoclean && apt-get --purge -y autoremove && rm -rf /var/lib/apt/lists/* && \
  rm -f ppolicy*.ldif

#USER openldap
HEALTHCHECK --interval=15s --timeout=8s \
  CMD ldapsearch -H ldaps://localhost:8389 -b dc=nodomain -x -LLL -s base || exit 1
ENTRYPOINT [ "run-openldap.sh" ]
