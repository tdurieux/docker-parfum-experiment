FROM centos:7

ADD packages/rpm/greyd.repo /etc/yum.repos.d/greyd.repo

RUN rpm --import https://greyd.org/repo/greyd_pkg_sign_pub.asc && \
        yum install -y greyd && \
        yum clean all && rm -rf /var/cache/yum

EXPOSE 8025/tcp

RUN ln -sf /dev/stdout /tmp/greyd.log

# Override config at /etc/greyd/greyd.conf
ENTRYPOINT [ "/usr/sbin/greyd", "-F" ]
