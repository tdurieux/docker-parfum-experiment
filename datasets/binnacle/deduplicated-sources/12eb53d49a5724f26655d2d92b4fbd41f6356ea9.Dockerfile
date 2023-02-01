FROM selenoid/base:5.0@@REQUIRES_JAVA@@

ARG VERSION
ARG CLEANUP

RUN \
        ( [ "$CLEANUP" != "true" ] && rm -f /etc/apt/apt.conf.d/docker-clean ) || true && \
        ( \
            ( \
                wget -O firefox.deb http://apt-repo:8080/firefox_amd64.deb && \
                apt-get update && \
                apt-get -y install libgtk-3-0 libstartup-notification0 \
            ) || \
            ( \ 
                wget -O firefox.deb http://apt-repo:8080/firefox_i386.deb && \
                dpkg --add-architecture i386 && \
                apt-get update && \
                apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386 libgtk2.0-0:i386 libasound2:i386 libdbus-glib-1-2:i386 libxt6:i386 && \
                mkdir flashplayer && \
                cd flashplayer && \
                wget -O flashplayer.tar.gz https://fpdownload.adobe.com/pub/flashplayer/pdc/27.0.0.187/flash_player_ppapi_linux.i386.tar.gz && \
                tar xvzf flashplayer.tar.gz && \
                cp libpepflashplayer.so /usr/lib/flashplugin-installer/libflashplayer.so && \
                cd .. && \
                rm -Rf flashplayer \
            ) \
        ) && \
        dpkg -i firefox.deb && \
        firefox --version && \
        ($CLEANUP && rm -Rf /tmp/* && rm -Rf /var/lib/apt/lists/* && rm -f firefox*.deb) || true
