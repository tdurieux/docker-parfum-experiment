FROM openshift/origin-source

RUN INSTALL_PKGS="origin-service-catalog" && \
    yum --enablerepo=origin-local-release install -y ${INSTALL_PKGS} && \
    rpm -V ${INSTALL_PKGS} && \
    yum clean all && rm -rf /var/cache/yum

CMD [ "/usr/bin/service-catalog" ]
