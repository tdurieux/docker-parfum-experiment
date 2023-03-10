FROM restreamio/gstreamer:dev-dependencies

ARG GSTREAMER_REPOSITORY=https://gitlab.freedesktop.org/philn/gstreamer.git

# 1.20-studio-rebase-220504 branch
ARG GSTREAMER_CHECKOUT=64f78d1d561cc25d571a411c64ada98c1cb8aa2b

ARG GST_PLUGINS_RS_REPOSITORY=https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git
ARG GST_PLUGINS_RS_CHECKOUT=c6238a6a9f35c34e8bd4f8f4ccc727a5f8c0e6b1

ARG LIBWPE_VERSION=1.12.0
ARG WPEBACKEND_FDO_VERSION=1.12.0
ARG WPEWEBKIT_VERSION=2.36.1

ARG GSTREAMER_CEF_REPOSITORY=https://github.com/centricular/gstcefsrc
ARG GSTREAMER_CEF_CHECKOUT=9c97fbd9abf0e7926819ffbad6a26a2e505bae84

COPY docker/sccache.toml /sccache.toml

COPY docker/build-gstreamer/download /download

RUN ["/download"]

COPY docker/build-gstreamer/compile /compile