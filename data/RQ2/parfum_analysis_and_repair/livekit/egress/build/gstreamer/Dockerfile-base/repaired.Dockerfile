FROM ubuntu:21.04

ARG GSTREAMER_VERSION

COPY install-dependencies /

RUN ["/install-dependencies"]

RUN wget https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-$GSTREAMER_VERSION.tar.xz && \
    tar -xf gstreamer-$GSTREAMER_VERSION.tar.xz && \
    rm gstreamer-$GSTREAMER_VERSION.tar.xz && \
    mv gstreamer-$GSTREAMER_VERSION gstreamer

RUN wget https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-$GSTREAMER_VERSION.tar.xz && \
    tar -xf gst-plugins-base-$GSTREAMER_VERSION.tar.xz && \
    rm gst-plugins-base-$GSTREAMER_VERSION.tar.xz && \
    mv gst-plugins-base-$GSTREAMER_VERSION gst-plugins-base

RUN wget https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-$GSTREAMER_VERSION.tar.xz && \
    tar -xf gst-plugins-bad-$GSTREAMER_VERSION.tar.xz && \
    rm gst-plugins-bad-$GSTREAMER_VERSION.tar.xz && \
    mv gst-plugins-bad-$GSTREAMER_VERSION gst-plugins-bad

RUN wget https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-$GSTREAMER_VERSION.tar.xz && \
    tar -xf gst-plugins-good-$GSTREAMER_VERSION.tar.xz && \
    rm gst-plugins-good-$GSTREAMER_VERSION.tar.xz && \
    mv gst-plugins-good-$GSTREAMER_VERSION gst-plugins-good

RUN wget https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-$GSTREAMER_VERSION.tar.xz && \
    tar -xf gst-plugins-ugly-$GSTREAMER_VERSION.tar.xz && \
    rm gst-plugins-ugly-$GSTREAMER_VERSION.tar.xz && \
    mv gst-plugins-ugly-$GSTREAMER_VERSION gst-plugins-ugly

RUN wget https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-$GSTREAMER_VERSION.tar.xz && \
    tar -xf gst-libav-$GSTREAMER_VERSION.tar.xz && \
    rm gst-libav-$GSTREAMER_VERSION.tar.xz && \
    mv gst-libav-$GSTREAMER_VERSION gst-libav