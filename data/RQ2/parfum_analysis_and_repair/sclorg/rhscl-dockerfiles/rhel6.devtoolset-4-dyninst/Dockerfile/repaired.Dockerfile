FROM rhel6

RUN yum install -y --setopt=tsflags=nodocs yum-utils && \
    yum-config-manager --enable rhel-server-rhscl-6-rpms && \
    yum-config-manager --enable rhel-6-server-optional-rpms && \
    yum clean all && rm -rf /var/cache/yum

RUN yum install -y --setopt=tsflags=nodocs devtoolset-4-dyninst && yum clean all && rm -rf /var/cache/yum



ENV	BASH_ENV=/etc/profile.d/cont-env.sh


ADD ./enabledevtoolset-4.sh /usr/share/cont-layer/common/env/enabledevtoolset-4.sh
ADD ./usr /usr
ADD ./etc /etc
ADD ./root /root

ENV HOME /home/default
RUN     groupadd -r default -f -g 1001 && \
        useradd -u 1001 -r -g default -d ${HOME} -s /sbin/nologin \
                        -c "Default Application User" default

USER 1001

ENTRYPOINT ["/usr/bin/container-entrypoint"]

CMD ["container-usage"]


