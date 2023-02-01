FROM johnshine/crossover-vnc:latest
MAINTAINER john.shine <mr.john.shine@gmail.com>
LABEL io.openshift.expose-services="5901:tcp"

ENV BOTTLE="BaiduNetDisk"
EXPOSE 5901

USER root
RUN yum check-update -y ; \
    yum install -y --setopt=tsflags=nodocs libv4l.i686 fontconfig.i686 libXcomposite.i686 libXinerama.i686 libgphoto2.i686 libxml2.i686 libxslt.i686 openldap.i686 sane-backends-libs.i686 mesa-dri-drivers.i686 isdn4k-utils.i686 gsm.i686 gstreamer-plugins-base.i686 lcms2.i686 mesa-libOSMesa.i686 libtiff.i686 gnutls.i686 glibc.i686 zlib.i686 freetype.i686 libgcc.i686 libXext.i686 alsa-lib.i686 cups-libs.i686 libXcursor.i686 libXi.i686 libXrandr.i686 libXrender.i686 libXxf86vm.i686 openssl.i686 libpng.i686 libX11.i686 mesa-libGL.i686 freetype.x86_64 glibc.x86_64 libICE.i686 libICE.x86_64 libSM.i686 libSM.x86_64 libX11.x86_64 libXext.x86_64 libgcc.x86_64 libpng.x86_64 nss-mdns.i686 nss-mdns.x86_64 pygtk2 zlib.x86_64 wqy-microhei-fonts && \
    yum clean all && rm -rf /var/cache/yum/*
RUN ln -s /usr/lib/libtiff.so.5.2.0 /usr/lib/libtiff.so.4 && \
    ln -s /usr/lib/libOSMesa.so.8.0.0 /usr/lib/libOSMesa.so.6

RUN wget https://raw.githubusercontent.com/john-shine/Docker-CodeWeavers_CrossOver-VNC/master/BaiduNetdisk/installers/rpm/mpg123-libs-1.23.6-2.sdl7.i686.rpm -O /tmp/mpg123-libs-1.23.6-2.sdl7.i686.rpm && yum localinstall -y --nogpgcheck /tmp/mpg123-libs-1.23.6-2.sdl7.i686.rpm && rm -f /tmp/mpg123-libs-1.23.6-2.sdl7.i686.rpm ; \
    wget https://raw.githubusercontent.com/john-shine/Docker-CodeWeavers_CrossOver-VNC/master/BaiduNetdisk/installers/rpm/openal-soft-1.16.0-2.sdl7.i686.rpm -O /tmp/openal-soft-1.16.0-2.sdl7.i686.rpm && yum localinstall -y --nogpgcheck /tmp/openal-soft-1.16.0-2.sdl7.i686.rpm && rm -f /tmp/openal-soft-1.16.0-2.sdl7.i686.rpm

WORKDIR ${HOME}

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN yum install -y --setopt=tsflags=nodocs kde-l10n-Chinese telnet && \
    yum reinstall -y glibc-common && \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

ENV LC_ALL "zh_CN.UTF-8"  

ENTRYPOINT ["/entrypoint.sh"]

USER ${USER}

ADD xstartup ${HOME}/.vnc/
RUN sudo chown ${UID}:${GID} ${HOME}/.vnc/xstartup && chmod +x ${HOME}/.vnc/xstartup
COPY Init.sh ${HOME}/.cxoffice/Init.sh
COPY fonts/ /tmp/fonts/
COPY installers /tmp/installers

# Always run the WM last!
RUN /bin/echo -e "export DISPLAY=${DISPLAY}"  >> ${HOME}/.vnc/xstartup
RUN /bin/echo -e "[ -r ${HOME}/.Xresources ] && xrdb ${HOME}/.Xresources\nxsetroot -solid grey"  >> ${HOME}/.vnc/xstartup
RUN cp ${HOME}/.vnc/xstartup ${HOME}/.vnc/xstartup_after

RUN /bin/echo -e "xterm -maximized -font -*-*-medium-r-*-*-18-*-*-*-*-*-iso8859-* -e ${HOME}/.cxoffice/Init.sh" >> ${HOME}/.vnc/xstartup

RUN /bin/echo -e "sudo mkdir -p /mnt/drive_d/BaiduNetdiskDownload" >> ${HOME}/.vnc/xstartup_after
RUN /bin/echo -e "sudo chown -R ${UID}:${GID} /mnt/drive_d; sudo chmod -R 755 /mnt/drive_d" >> ${HOME}/.vnc/xstartup_after
RUN /bin/echo -e "ln -snf /mnt/drive_d/BaiduNetdiskDownload ${HOME}/BaiduNetdiskDownload" >> ${HOME}/.vnc/xstartup_after
RUN /bin/echo -e "ln -snf /mnt/drive_d/BaiduNetdiskDownload ${HOME}/.cxoffice/${BOTTLE}/drive_c/BaiduNetdiskDownload" >> ${HOME}/.vnc/xstartup_after
RUN /bin/echo -e "wine --bottle ${BOTTLE} \"c:\\\\\\\\Program Files\\\\\\\\BaiduNetdisk\\\\\\\\baidunetdisk.exe\"" >> ${HOME}/.vnc/xstartup_after
RUN /bin/echo -e "tail -f /dev/null" >> ${HOME}/.vnc/xstartup_after

