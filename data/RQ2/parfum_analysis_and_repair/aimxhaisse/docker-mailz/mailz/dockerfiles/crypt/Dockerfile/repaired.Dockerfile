FROM ubuntu:vivid
MAINTAINER Sébastien Rannou <mxs@sbrk.org> (@aimxhaisse)

RUN apt-get update -q -y \
    && apt-get install --no-install-recommends -q -y \
       opensmtpd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT bash -c 'read -s -r -p "Enter the password you want to encrypt: " PASS && smtpctl encrypt "$PASS"'
