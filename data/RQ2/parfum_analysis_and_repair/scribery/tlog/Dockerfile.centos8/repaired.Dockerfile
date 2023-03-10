FROM centos:8
COPY . .
RUN dnf -y install dnf-plugins-core
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf config-manager --set-enabled PowerTools
RUN dnf repolist
RUN dnf -y install autoconf \
                   automake \
                   make \
                   libtool \
                   rpm-build \
                   systemd-devel \
                   json-c-devel \
                   libcurl-devel \
                   libutempter-devel \
                   openssh-server \
                   openssh-clients \
                   passwd \
                   glibc-locale-source \
                   glibc-langpack-ru \
                   cracklib-dicts \
                   audit \
    && dnf clean all \
    && sed -i 's/.*PermitRootLogin .*/#&/g' /etc/ssh/sshd_config \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && systemctl enable sshd

EXPOSE 22
CMD [ "/sbin/init" ]