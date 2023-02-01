FROM sonic-slave-stretch-base

# Add user
ARG user
ARG uid
ARG guid
ARG hostname

ENV BUILD_HOSTNAME $hostname
ENV USER $user

RUN groupadd -f -r -g $guid g$user

RUN useradd $user -l -u $uid -g $guid -d /var/$user -m -s /bin/bash

RUN gpasswd -a $user docker

# Config git for stg
RUN su $user -c "git config --global user.name $user"
RUN su $user -c "git config --global user.email $user@contoso.com"

COPY sonic-jenkins-id_rsa.pub /var/$user/.ssh/authorized_keys2
RUN chown $user /var/$user/.ssh -R
RUN chmod go= /var/$user/.ssh -R

# Add user to sudoers
RUN echo "$user ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

USER $user
