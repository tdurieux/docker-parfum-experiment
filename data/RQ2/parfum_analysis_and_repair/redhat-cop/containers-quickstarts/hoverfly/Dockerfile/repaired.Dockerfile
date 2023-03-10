FROM registry.access.redhat.com/ubi8/ubi

ENV HOVERFLY_DOWNLOAD_URI https://github.com/SpectoLabs/hoverfly/releases/download/v1.2.0/hoverfly_bundle_linux_amd64.zip
ENV HOME /home/hoverfly

RUN PACKAGE_LIST="less unzip" && \
    yum install -y $PACKAGE_LIST && \
    rpm -V $PACKAGE_LIST && \
    yum clean all -y && \
    curl -f -o /tmp/hoverfly.zip -L $HOVERFLY_DOWNLOAD_URI && \
    unzip /tmp/hoverfly.zip -d /tmp/hoverfly && \
    mv /tmp/hoverfly/hover* /usr/bin && \
    rm -r /tmp/hoverfly /tmp/hoverfly.zip && \
    mkdir -m 775 $HOME && \
    chmod 775 /etc/passwd && rm -rf /var/cache/yum

WORKDIR $HOME

ADD ./s2i /usr/libexec/s2i

USER 1001

EXPOSE 8500 8888

CMD ["/usr/libexec/s2i/run"]
