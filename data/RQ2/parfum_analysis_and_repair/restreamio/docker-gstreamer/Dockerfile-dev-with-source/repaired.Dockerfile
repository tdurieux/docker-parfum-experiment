FROM restreamio/gstreamer:dev-downloaded

ARG WEBKIT_USE_SCCACHE=0

ENV DEBUG=true
ENV OPTIMIZATIONS=false

# Compile binaries with debug symbols and keep source code
RUN ["/compile"]