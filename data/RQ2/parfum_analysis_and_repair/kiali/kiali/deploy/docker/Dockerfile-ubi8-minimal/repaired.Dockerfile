FROM registry.access.redhat.com/ubi8-minimal

LABEL maintainer="kiali-dev@googlegroups.com"

ENV KIALI_HOME=/opt/kiali \
    PATH=$KIALI_HOME:$PATH

WORKDIR $KIALI_HOME

RUN microdnf install -y shadow-utils && \
    microdnf clean all && \
    rm -rf /var/cache/yum && \
    adduser --uid 1000 kiali

COPY kiali $KIALI_HOME/

ADD console $KIALI_HOME/console/

RUN chown -R kiali:kiali $KIALI_HOME/console && \
    chmod -R g=u $KIALI_HOME/console

USER 1000

ENTRYPOINT ["/opt/kiali/kiali"]