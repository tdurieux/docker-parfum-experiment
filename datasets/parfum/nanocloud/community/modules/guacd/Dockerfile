FROM debian:jessie
RUN apt-get update && apt-get install -y build-essential git-core cmake xsltproc libssl-dev libx11-dev libxext-dev libxinerama-dev \
  libxcursor-dev libxdamage-dev libxv-dev libxkbfile-dev libasound2-dev libcups2-dev libxml2 libxml2-dev \
  libxrandr-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libxi-dev libgstreamer-plugins-base1.0-dev \
  libavutil-dev libavcodec-dev ghostscript libcairo2-dev libjpeg62-turbo-dev libpng12-dev libossp-uuid-dev \
  libvorbis-dev libssl-dev dh-autoreconf
RUN git clone https://github.com/FreeRDP/FreeRDP /tmp/FreeRDP
WORKDIR /tmp/FreeRDP
RUN git checkout stable-1.1
COPY ./FreeRDP /tmp/FreeRDP
RUN patch include/freerdp/settings.h include/freerdp/settings.h.diff  && rm include/freerdp/settings.h.diff
RUN cmake . && make && make install && ldconfig
RUN git clone https://github.com/glyptodon/guacamole-server /tmp/guacamole-server
WORKDIR /tmp/guacamole-server
RUN git checkout 0.9.9
COPY ./guacamole-server /tmp/guacamole-server
RUN patch src/protocols/rdp/rdp_disp.c src/protocols/rdp/rdp_disp.c.diff
RUN autoreconf -fi && ./configure && make && make install && ldconfig
CMD guacd -f -L 'debug' -b 0.0.0.0
