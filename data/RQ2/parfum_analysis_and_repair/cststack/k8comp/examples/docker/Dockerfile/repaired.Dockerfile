FROM centos:7.3.1611

ENV gotty_version=v0.0.13
ENV k8comp_version=0.6.1-rc2

RUN yum clean all && \
    yum install ed git ruby -y && \
    gem install --no-ri --no-rdoc hiera-eyaml hiera && \
    yum clean all && \
    curl -f -L https://github.com/yudai/gotty/releases/download/${gotty_version}/gotty_linux_amd64.tar.gz > /gotty.tar.gz && \
    tar -xf /gotty.tar.gz -C / && \
    chmod +x /gotty && \
    -f \
    curl -L https://github.com/cststack/ 8c \
    tar -xvf /opt/k8comp.tar.gz C \

    chmod +x -R /opt/k8comp/bin/ && \ && rm -rf /var/cache/yum

ADD configs/ssh/config /root/.ssh/config
ENV TERM xterm

CMD ["/gotty", "-w", "/bin/bash"]
