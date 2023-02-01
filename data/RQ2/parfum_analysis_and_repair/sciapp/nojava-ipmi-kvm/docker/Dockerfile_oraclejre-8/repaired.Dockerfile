FROM debian:stretch
LABEL maintainer="Ingo Meyer <i.meyer@fz-juelich.de>"

# Install needed packages and Java dependencies (second `apt-get install` call)
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl eterm fluxbox net-tools procps python-numpy \
                                               python-pip python-pyquery python-setuptools python-wheel supervisor tar \
                                               x11vnc xvfb && \
    apt-get install -y --no-install-recommends adwaita-icon-theme ca-certificates ca-certificates-java \
                                               dconf-gsettings-backend dconf-service fontconfig fontconfig-config \
                                               fonts-dejavu-core glib-networking glib-networking-common \
                                               glib-networking-services gnome-icon-theme gsettings-desktop-schemas \
                                               gtk-update-icon-cache hicolor-icon-theme java-common libasound2 \
                                               libasound2-data libasyncns0 libatk-bridge2.0-0 libatk-wrapper-java \
                                               libatk-wrapper-java-jni libatk1.0-0 libatk1.0-data libatspi2.0-0 \
                                               libavahi-client3 libavahi-common-data libavahi-common3 libbsd0 \
                                               libcairo-gobject2 libcairo2 libcolord2 libcroco3 libcups2 libdatrie1 \
                                               libdbus-1-3 libdconf1 libdrm2 libegl1-mesa libepoxy0 libexpat1 libffi6 \
                                               libflac8 libfontconfig1 libfontenc1 libfreetype6 libgbm1 \
                                               libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-common libgif7 libgl1-mesa-glx \
                                               libglapi-mesa libglib2.0-0 libgmp10 libgnutls30 libgraphite2-3 \
                                               libgssapi-krb5-2 libgtk-3-0 libgtk-3-common libgtk2.0-0 \
                                               libgtk2.0-common libharfbuzz0b libhogweed4 libice6 libicu57 libjbig0 \
                                               libjpeg62-turbo libjson-glib-1.0-0 libjson-glib-1.0-common libk5crypto3 \
                                               libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libnspr4 libnss3 \
                                               libogg0 libp11-kit0 libpango-1.0-0 libpangocairo-1.0-0 \
                                               libpangoft2-1.0-0 libpcsclite1 libpixman-1-0 libpng16-16 libproxy1v5 \
                                               libpulse0 librest-0.7-0 librsvg2-2 librsvg2-common libsm6 libsndfile1 \
                                               libsoup-gnome2.4-1 libsoup2.4-1 libsqlite3-0 libssl1.1 libtasn1-6 \
                                               libthai-data libthai0 libtiff5 libvorbis0a libvorbisenc2 \
                                               libwayland-client0 libwayland-cursor0 libwayland-egl1-mesa \
                                               libwayland-server0 libwrap0 libx11-6 libx11-data libx11-xcb1 libxau6 \
                                               libxaw7 libxcb-dri2-0 libxcb-dri3-0 libxcb-glx0 libxcb-present0 \
                                               libxcb-render0 libxcb-shape0 libxcb-shm0 libxcb-sync1 libxcb-xfixes0 \
                                               libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxdmcp6 libxext6 \
                                               libxfixes3 libxft2 libxi6 libxinerama1 libxkbcommon0 libxml2 libxmu6 \
                                               libxmuu1 libxpm4 libxrandr2 libxrender1 libxshmfence1 libxt6 libxtst6 \
                                               libxv1 libxxf86dga1 libxxf86vm1 openssl shared-mime-info ucf x11-common \
                                               x11-utils xkb-data && \
    # Add support for asian characters
    apt-get install -y --no-install-recommends fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho \
                                               fonts-ipafont-gothic fonts-unfonts-core && \
    pip install --no-cache-dir future requests 'websockify<0.10' && \
    rm -rf /var/lib/apt/lists/*

RUN NOVNC_VERSION="1.1.0" && \
    curl -f -o /tmp/novnc.tar.gz -L "https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz" && \
    tar -xvf /tmp/novnc.tar.gz -C /opt/ && \
    ln -s "/opt/noVNC-${NOVNC_VERSION}/utils/launch.sh" /usr/local/bin/launch_novnc && \
    rm -f /tmp/novnc.tar.gz

COPY jre-8u251-linux-x64.tar.gz /opt/java_packages/8u251/jre-8u251-linux-x64.tar.gz

COPY entrypoint.sh /usr/local/bin/docker-entrypoint
COPY get_java_viewer.py /usr/local/bin/get_java_viewer
COPY import_jnlp_cert.py /usr/local/bin/import_jnlp_cert.py
COPY supervisord_oraclejre-8.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /root/

ENV DISPLAY :0
EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
