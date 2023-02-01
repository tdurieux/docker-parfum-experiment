FROM debian:11

RUN apt update && \
    apt -y upgrade && \
    apt -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install python3 \
                   python3-pip \
                   python3-setuptools && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir appimage-builder

RUN apt -y --no-install-recommends install strace patchelf libkrb5-dev wget fuse file && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O /usr/local/bin/appimagetool
RUN chmod +x /usr/local/bin/appimagetool

CMD cd /nagstamon/build/appimage && \
    /usr/local/bin/appimage-builder
