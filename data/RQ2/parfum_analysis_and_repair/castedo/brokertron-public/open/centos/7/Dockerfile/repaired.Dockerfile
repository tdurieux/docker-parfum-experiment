FROM brokertron/centos:7
MAINTAINER Castedo Ellerman <castedo@castedo.com>

RUN yum install -y supervisor && rm -rf /var/cache/yum
RUN yum install -y tigervnc-server-minimal && rm -rf /var/cache/yum
RUN yum install -y glibc xkeyboard-config xorg-x11-server-Xvfb xorg-x11-fonts-Type1 ttmkfdir gsettings-desktop-schemas && rm -rf /var/cache/yum
RUN yum install -y ca-certificates java-openjdk && rm -rf /var/cache/yum
RUN yum install -y nmap-ncat && rm -rf /var/cache/yum
RUN yum install -y ibgateway && rm -rf /var/cache/yum

# 4001 = IB API
# 5900 = VNC
EXPOSE 4001 5900

COPY supervisord.conf /etc/supervisord.conf
COPY run-ibgateway /usr/bin/run-ibgateway

# set an empty VNC password
RUN echo | vncpasswd -f > /etc/vnc-passwd

COPY enter-gateway /root/enter-gateway
ENTRYPOINT ["/root/enter-gateway"]

