FROM fedora:rawhide
WORKDIR /tlbuild
COPY . .
RUN dnf -y --nogpgcheck install autoconf \
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