FROM alpine
MAINTAINER David Personette <dperson@gmail.com>

# Install emby
RUN export LANG=C.UTF-8 && \
    ff_url='http://johnvansickle.com/ffmpeg/releases' && \
    glib_url='https://github.com/sgerrand/alpine-pkg-glibc/releases/download'&&\
    glib_version=2.32-r0 && \
    glibc_base=glibc-${glib_version}.apk && \
    glibc_bin=glibc-bin-${glib_version}.apk && \
    glibc_i18n=glibc-i18n-${glib_version}.apk && \
    monourl='https://archive.archlinux.org/packages/m/mono' && \
    mono_version=6.4.0.198-2 && \
    key=/etc/apk/keys/sgerrand.rsa.pub && \
    url='https://github.com/MediaBrowser/Emby.Releases/releases/download' && \
    version=4.5.4.0 && \
    apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl shadow sqlite-libs tini tzdata \
                zstd && \
    curl -f -LSs https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o $key && \
    curl -f -LOSs $glib_url/$glib_version/$glibc_base && \
    curl -f -LOSs $glib_url/$glib_version/$glibc_bin && \
    curl -f -LOSs $glib_url/$glib_version/$glibc_i18n && \
    apk --no-cache --no-progress add $glibc_base $glibc_bin $glibc_i18n && \
    { /usr/glibc-compat/bin/localedef -c -iPOSIX -fUTF-8 $LANG || :; } && \
    ln -s libsqlite3.so.0 /usr/lib/libsqlite3.so && \
    curl -f -LSs $monourl/mono-${mono_version}-x86_64.pkg.tar.zst \
                -o mono.tar.zst && \
    zstdcat mono.tar.zst | tar xf - && \
    addgroup -S emby && \
    adduser -S -D -H -h /usr/lib/emby-server -s /sbin/nologin -G emby \
                -g 'Emby User' emby && \
    echo "Downloading version: $version" && \
    curl -f -LSs $url/$version/embyserver-netframework_$version.zip -o emby.zip && \
    curl -f -LSs "$ff_url/ffmpeg-release-amd64-static.tar.xz" -o ffmpeg.txz && \
    { tar --strip-components=1 -C /bin -xf ffmpeg.txz "*/ffmpeg" 2>&-||:; } && \
    { tar --strip-components=1 -C /bin -xf ffmpeg.txz "*/ffprobe" 2>&-||:; } && \
    mkdir -p /config /media /usr/lib/emby-server && \
    unzip emby.zip -d /usr/lib/emby-server && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    chown -Rh root. /bin/ff* /usr/lib/emby-server && \
    chown -Rh emby. /config /media && \
    apk del glibc-i18n zstd && \
    rm -rf /tmp/* /var/cache/* emby.zip ffmpeg.txz glibc* $key mono.tar.zst

COPY emby.sh /usr/bin/

EXPOSE 8096 8920 7359/udp 1900/udp

HEALTHCHECK --interval=60s --timeout=15s --start-period=90s \
            CMD curl -L http://localhost:8096/

VOLUME ["/config", "/media"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/emby.sh"]