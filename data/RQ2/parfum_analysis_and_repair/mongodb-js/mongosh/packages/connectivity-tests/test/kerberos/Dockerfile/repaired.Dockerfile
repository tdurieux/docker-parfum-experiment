FROM node:16

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y krb5-user && rm -rf /var/lib/apt/lists/*;

COPY krb5.conf /etc/krb5.conf
COPY kerberos-run.sh /tmp/kerberos-run.sh

CMD [ "/tmp/kerberos-run.sh" ]
