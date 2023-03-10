FROM centos:8
RUN yum install -y https://github.com/frobware/haproxy-hacks/raw/master/RPMs/haproxy24-2.4.1-1.el8.x86_64.rpm && rm -rf /var/cache/yum
RUN haproxy -vv
RUN INSTALL_PKGS="rsyslog procps-ng util-linux socat" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all && \
    mkdir -p /var/lib/haproxy/router/{certs,cacerts,whitelists} && \
    mkdir -p /var/lib/haproxy/{conf/.tmp,run,bin,log} && \
    touch /var/lib/haproxy/conf/{{os_http_be,os_edge_reencrypt_be,os_tcp_be,os_sni_passthrough,os_route_http_redirect,cert_config,os_wildcard_domain}.map,haproxy.config} && \
    setcap 'cap_net_bind_service=ep' /usr/sbin/haproxy && \
    chown -R :0 /var/lib/haproxy && \
    chmod -R g+w /var/lib/haproxy && rm -rf /var/cache/yum
COPY images/router/haproxy/ /var/lib/haproxy/
COPY openshift-router /usr/bin/openshift-router
USER 1001
EXPOSE 80 443 7000
WORKDIR /var/lib/haproxy/conf
ENV XDG_CONFIG_HOME=/tmp \
    TEMPLATE_FILE=/var/lib/haproxy/conf/haproxy-config.template \
    RELOAD_SCRIPT=/var/lib/haproxy/reload-haproxy
ENTRYPOINT ["/usr/bin/openshift-router", "--v=4"]
