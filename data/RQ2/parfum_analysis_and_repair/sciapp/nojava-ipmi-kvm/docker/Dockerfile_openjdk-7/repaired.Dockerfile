FROM debian:jessie
LABEL maintainer="Ingo Meyer <i.meyer@fz-juelich.de>"

# Install needed packages and Java dependencies (second `apt-get install` call)
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl eterm fluxbox net-tools procps python-numpy \
                                               python-pip python-pyquery python-wheel supervisor tar x11vnc xvfb && \
    apt-get install -y --no-install-recommends ca-certificates-java initscripts java-common libasound2 \
                                               libatk-wrapper-java-jni libatk1.0-0 libc6 libcairo2 libcups2 \
                                               libfontconfig1 libfreetype6 libgcc1 libgdk-pixbuf2.0-0 libgif4 \
                                               libgl1-mesa-glx libglib2.0-0 libgtk2.0-0 libjpeg62-turbo libkrb5-3 \
                                               liblcms2-2 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 \
                                               libpcsclite1 libpng12-0 libpulse0 libsctp1 libstdc++6 libx11-6 \
                                               libxcomposite1 libxext6 libxi6 libxinerama1 libxrandr2 libxrender1 \
                                               libxtst6 tzdata-java zlib1g && \
    # Add support for asian characters
    apt-get install -y --no-install-recommends fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho \
                                               fonts-ipafont-gothic fonts-unfonts-core && \
    pip install --no-cache-dir future requests 'websockify<0.10' && \
    rm -rf /var/lib/apt/lists/*

RUN for java_version in "7u51" "7u79" "7u181"; do \
        mkdir -p "/opt/java_packages/${java_version}"; \
    done && \
    cd "/opt/java_packages/7u51" && \
    for package_url in "http://snapshot.debian.org/archive/debian/20140401T220416Z/pool/main/o/openjdk-7/openjdk-7-jre_7u51-2.4.6-1_amd64.deb" \
                       "http://snapshot.debian.org/archive/debian/20140401T220416Z/pool/main/o/openjdk-7/openjdk-7-jre-headless_7u51-2.4.6-1_amd64.deb" \
                       "http://snapshot.debian.org/archive/debian/20141009T042436Z/pool/main/libj/libjpeg8/libjpeg8_8d1-2_amd64.deb"; do \
        curl -f -O -L "${package_url}" || return 1; \
    done && \
    cd "/opt/java_packages/7u79" && \
    for package_url in "http://snapshot.debian.org/archive/debian/20150724T034333Z/pool/main/o/openjdk-7/openjdk-7-jre_7u79-2.5.6-1_amd64.deb" \
                       "http://snapshot.debian.org/archive/debian/20150724T034333Z/pool/main/o/openjdk-7/openjdk-7-jre-headless_7u79-2.5.6-1_amd64.deb" \
                       "http://snapshot.debian.org/archive/debian/20141009T042436Z/pool/main/libj/libjpeg8/libjpeg8_8d1-2_amd64.deb"; do \
        curl -f -O -L "${package_url}" || return 1; \
    done && \
    cd "/opt/java_packages/7u181" && \
    for package_url in "http://snapshot.debian.org/archive/debian-security/20180610T194921Z/pool/updates/main/o/openjdk-7/openjdk-7-jre_7u181-2.6.14-1~deb8u1_amd64.deb" \
                       "http://snapshot.debian.org/archive/debian-security/20180610T194921Z/pool/updates/main/o/openjdk-7/openjdk-7-jre-headless_7u181-2.6.14-1~deb8u1_amd64.deb"; do \
        curl -f -O -L "${package_url}" || return 1; \
    done && \
    mkdir "/opt/icedtea" && \
    cd "/opt/icedtea" && \
    for package_url in "http://snapshot.debian.org/archive/debian/20160526T040703Z/pool/main/i/icedtea-web/icedtea-7-plugin_1.5.3-1_amd64.deb" \
                       "http://snapshot.debian.org/archive/debian/20160526T040703Z/pool/main/i/icedtea-web/icedtea-netx_1.5.3-1_amd64.deb" \
                       "http://snapshot.debian.org/archive/debian/20160526T040703Z/pool/main/i/icedtea-web/icedtea-netx-common_1.5.3-1_all.deb"; do \
        curl -f -O -L "${package_url}" || return 1; \
    done

RUN NOVNC_VERSION="1.1.0" && \
    curl -f -o /tmp/novnc.tar.gz -L "https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz" && \
    tar -xvf /tmp/novnc.tar.gz -C /opt/ && \
    ln -s "/opt/noVNC-${NOVNC_VERSION}/utils/launch.sh" /usr/local/bin/launch_novnc && \
    rm -f /tmp/novnc.tar.gz

COPY entrypoint.sh /usr/local/bin/docker-entrypoint
COPY get_java_viewer.py /usr/local/bin/get_java_viewer
COPY import_jnlp_cert.py /usr/local/bin/import_jnlp_cert.py
COPY supervisord_openjdk-7.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /root/

ENV DISPLAY :0
EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
