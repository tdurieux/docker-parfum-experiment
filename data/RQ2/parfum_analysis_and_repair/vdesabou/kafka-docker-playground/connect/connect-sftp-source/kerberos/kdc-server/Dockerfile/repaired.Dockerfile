FROM debian:jessie

EXPOSE 749 88/udp

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get -qq -y --no-install-recommends install locales krb5-kdc krb5-admin-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq clean

ENV REALM ${REALM:-EXAMPLE.COM}
ENV SUPPORTED_ENCRYPTION_TYPES ${SUPPORTED_ENCRYPTION_TYPES:-aes256-cts-hmac-sha1-96:normal}
ENV KADMIN_PRINCIPAL ${KADMIN_PRINCIPAL:-kadmin/admin}
ENV KADMIN_PASSWORD ${KADMIN_PASSWORD:-adminpassword}

COPY init-script.sh /tmp/
CMD /tmp/init-script.sh
