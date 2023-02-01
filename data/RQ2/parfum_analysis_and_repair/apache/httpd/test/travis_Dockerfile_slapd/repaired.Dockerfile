FROM ubuntu:bionic
RUN echo slapd slapd/password1 password travis | debconf-set-selections
RUN echo slapd slapd/password2 password travis | debconf-set-selections
RUN echo slapd slapd/internal/adminpw password travis | debconf-set-selections
RUN echo slapd slapd/internal/generated_adminpw password travis | debconf-set-selections
RUN echo slapd slapd/domain string example.com | debconf-set-selections
RUN apt-get update && apt-get -y --no-install-recommends install slapd ldap-utils && rm -rf /var/lib/apt/lists/*;
# With -d passed, slapd stays in the foreground
CMD /usr/sbin/slapd -d1 '-h ldap:// ldapi:///'
