FROM debian:jessie  
  
MAINTAINER Holger Steinhauer <hlibrenz@gmail.com>  
  
ENV OPENLDAP_VERSION 2.4.40  
RUN apt-get update && \  
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \  
slapd=${OPENLDAP_VERSION}* && \  
apt-get clean && \  
rm -rf /var/lib/apt/lists/*  
  
RUN mv /etc/ldap /etc/ldap.dist  
  
EXPOSE 389  
VOLUME ["/etc/ldap", "/var/lib/ldap"]  
  
COPY modules/ /etc/ldap.dist/modules  
  
COPY entrypoint.sh /entrypoint.sh  
  
ENTRYPOINT ["/entrypoint.sh"]  
  
CMD ["slapd", "-d", "32768", "-u", "openldap", "-g", "openldap"]  

