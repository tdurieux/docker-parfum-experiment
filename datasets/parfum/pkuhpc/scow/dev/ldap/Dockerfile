FROM centos:7

WORKDIR /ldap
COPY dev/ldap/provider.sh .

RUN ./provider.sh docker

VOLUME [ "/var/lib/ldap" ]

CMD ["slapd" ,"-u", "ldap", "-h", "ldap:/// ldapi:///", "-d", "0"]
