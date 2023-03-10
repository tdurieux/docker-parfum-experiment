ARG version=33
FROM fedora:${version}
RUN yum -y install dnf sudo xorg-x11-server-Xvfb \
 && dnf install -y gtk4-devel \
 && useradd -ms /bin/bash gtk4 && rm -rf /var/cache/yum
RUN echo '#!/usr/bin/env bash' > /usr/bin/gtk4-builder-tool.sh \
 && echo 'MYARGS="$@"' >> /usr/bin/gtk4-builder-tool.sh \
 && echo 'Xvfb :0 -screen 0 1024x768x24 > /dev/null 2>&1 &' >> /usr/bin/gtk4-builder-tool.sh \
 && echo 'sudo -u gtk4 sh -c "DISPLAY=:0.0 gtk4-builder-tool $MYARGS 2>/dev/null"' >> /usr/bin/gtk4-builder-tool.sh \
 && chmod +x /usr/bin/gtk4-builder-tool.sh
WORKDIR /home/gtk4/app
ENTRYPOINT [ "/usr/bin/gtk4-builder-tool.sh" ]
