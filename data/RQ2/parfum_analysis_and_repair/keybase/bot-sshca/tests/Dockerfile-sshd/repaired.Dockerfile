# This dockerfile builds an openssh server that will accept SSH keys signed by the key provided in /shared/keybase-ca-key.pub
# It takes in a build argument and only allows keys with the build argument in the principals field
FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/run/sshd

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

ARG user_principal
ARG root_principal
RUN mkdir /etc/ssh/auth_principals/
RUN useradd -ms /bin/bash user
RUN echo "${user_principal}" > /etc/ssh/auth_principals/user
RUN echo "${root_principal}" > /etc/ssh/auth_principals/root

# Set up the SSH server to trust the CA key based off of the files in /etc/ssh/auth_principals/
RUN echo "TrustedUserCAKeys /etc/ssh/ca.pub\nAuthorizedPrincipalsFile /etc/ssh/auth_principals/%u" >> /etc/ssh/sshd_config

# Used in the integration tests by reading the contents of this file. See test_kssh.py
RUN echo -n "uniquestring" > /etc/unique

EXPOSE 22

CMD ln -sf /shared/keybase-ca-key.pub /etc/ssh/ca.pub && /usr/sbin/sshd -D
