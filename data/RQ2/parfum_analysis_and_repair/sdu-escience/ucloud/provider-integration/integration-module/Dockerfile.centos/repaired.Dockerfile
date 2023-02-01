FROM centos:7
RUN yum -y install curl wget unzip zip sudo jansson curl openssl11 && rm -rf /var/cache/yum
RUN export SDKMAN_DIR="/usr/local/sdkman" && curl -f -s "https://get.sdkman.io" | bash
RUN bash -c "export SDKMAN_DIR='/usr/local/sdkman' && source /usr/local/sdkman/bin/sdkman-init.sh && \
    yes | sdk i java 11.0.11.hs-adpt && \
    yes | sdk i gradle 6.9"

RUN groupadd -g 997 munge
RUN useradd -u 999 -g 997 munge
RUN useradd --system --user-group ucloud
RUN mkdir -p /var/run/ucloud/envoy
RUN chown -R ucloud: /var/run/ucloud
RUN echo 'ucloud  ALL=(%ucloud) NOPASSWD: /usr/bin/ucloud, /opt/ucloud/build/bin/native/debugExecutable/ucloud-integration-module.kexe' >> /etc/sudoers

RUN useradd --user-group testuser
WORKDIR /usr/bin
RUN ln -s /opt/ucloud/build/bin/native/debugExecutable/ucloud-integration-module.kexe ucloud
COPY default_config /opt/ucloud-default-config
RUN chmod +x /opt/ucloud-default-config/config_installer.sh
WORKDIR /opt/ucloud
