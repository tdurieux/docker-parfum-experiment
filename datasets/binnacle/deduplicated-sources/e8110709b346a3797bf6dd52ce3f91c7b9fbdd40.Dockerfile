FROM node:0.10
MAINTAINER Petr Sloup <petr.sloup@klokantech.com>
# Based on work by Lukas Martinelli

# make sure the mapbox fonts are available on the system
RUN mkdir -p /tmp/mapbox-studio-default-fonts && \
    mkdir -p /fonts && \
    git clone https://github.com/mapbox/mapbox-studio-default-fonts.git /tmp/mapbox-studio-default-fonts && \
    cp /tmp/mapbox-studio-default-fonts/**/*.otf /fonts && \
    cp /tmp/mapbox-studio-default-fonts/**/*.ttf /fonts && \
    rm -rf /tmp/mapbox-studio-default-fonts

# download fonts required for osm bright
RUN wget -q -P /fonts https://github.com/aaronlidman/Toner-for-Tilemill/raw/master/toner4tilemill/fonts/Arial-Bold.ttf && \
    wget -q -P /fonts https://github.com/aaronlidman/Toner-for-Tilemill/raw/master/toner4tilemill/fonts/Arial-Regular.ttf && \
    wget -q -P /fonts https://github.com/aaronlidman/Toner-for-Tilemill/raw/master/toner4tilemill/fonts/Arial-Unicode-Bold-Italic.ttf && \
    wget -q -P /fonts https://github.com/aaronlidman/Toner-for-Tilemill/raw/master/toner4tilemill/fonts/Arial-Unicode-Bold.ttf && \
    wget -q -P /fonts https://github.com/aaronlidman/Toner-for-Tilemill/raw/master/toner4tilemill/fonts/Arial-Unicode-Italic.ttf && \
    wget -q -P /fonts https://github.com/aaronlidman/Toner-for-Tilemill/raw/master/toner4tilemill/fonts/Arial-Unicode-Regular.ttf

ENV MAPNIK_FONT_PATH=/fonts

RUN mkdir -p /usr/src/app && mkdir -p /project
WORKDIR /usr/src/app
# only install minimal amount of tessera packages
# be careful as some tessera packages collide with itself
RUN npm install \
    mbtiles@0.8.2  \
    tilelive-tmstyle@0.4.2 \
    tilelive-xray@0.2.0  \
    tilelive-http@0.8.0

COPY / /usr/src/app
RUN npm install

VOLUME /data
ENV SOURCE_DATA_DIR=/data \
    DEST_DATA_DIR=/project \
    PORT=80 \
    MAPNIK_FONT_PATH=/fonts \
    DOMAINS=

EXPOSE 80
CMD ["/usr/src/app/run.sh"]
