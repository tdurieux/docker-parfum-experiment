#docker run -p 389:389 -p 636:636 --name openldap --detach osixia/openldap:1.2.4
FROM osixia/openldap:1.2.4
#COPY *.ldif /container/service/slapd/assets/test/ 
#ADD bootstrap /container/service/slapd/assets/config/bootstrap
#COPY *.ldif /container/service/slapd/assets/config/bootstrap/ldif/
#COPY wait.sh /tmp
#RUN apt-get install net-tools
#RUN chmod +x /tmp/wait.sh
#RUN /tmp/wait.sh &
#ENV "LDAP_TLS_VERIFY_CLIENT"="try"
#ENV "LDAP_DOMAIN"="crackq.org"
#ENV "LDAP_ORGANISATION"="crackq"
#ENV "LDAP_TLS_CRT_FILENAME"="certificate.crt"
#ENV "LDAP_TLS_KEY_FILENAME"="private.key"
#ENV "LDAP_TLS_CA_CRT_FILENAME"="www.crackq.org.crt"