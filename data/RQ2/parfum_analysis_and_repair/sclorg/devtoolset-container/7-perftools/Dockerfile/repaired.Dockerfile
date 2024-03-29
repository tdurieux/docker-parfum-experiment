FROM centos/s2i-core-centos7
LABEL MAINTAINER Red Hat, Inc.

ENV SUMMARY="Red Hat Developer Toolset 7 Performance Tools container image" \
    DESCRIPTION="Performance tools: systemtap, valgrind, dyninst, elfutils, oprofile"

LABEL com.redhat.component="devtoolset-7-perftools-container" \
      name="centos/devtoolset-7-perftools-centos7" \
      version="7" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Developer Toolset 7 Performance Tools" \
      io.k8s.min-memory="2Gi" \
      usage="docker run -ti -v /bin:/host:ro centos/devtoolset-7-perftools-centos7 eu-objdump -d /host/<binary>"

RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="devtoolset-7-systemtap devtoolset-7-valgrind devtoolset-7-dyninst devtoolset-7-dyninst-devel devtoolset-7-elfutils devtoolset-7-elfutils-devel devtoolset-7-oprofile devtoolset-7-oprofile-jit devtoolset-7-oprofile-devel" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && rm -rf /var/cache/yum

# Copy extra files to the image.
COPY ./root/ /

ENV HOME=/root \
    PATH=/root/bin:/opt/rh/devtoolset-7/root/usr/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN mkdir -p ${HOME} && \
    chmod u+x /usr/bin/usage && \
    rpm-file-permissions

USER 0

WORKDIR ${HOME}

# Enable the SCL for all bash scripts.
ENV BASH_ENV=/root/etc/scl_enable \
    ENV=/root/etc/scl_enable \
    PROMPT_COMMAND=". /root/etc/scl_enable"

# Set the default CMD to print the usage of the perftools image
ENTRYPOINT ["container-entrypoint"]
CMD ["usage"]
