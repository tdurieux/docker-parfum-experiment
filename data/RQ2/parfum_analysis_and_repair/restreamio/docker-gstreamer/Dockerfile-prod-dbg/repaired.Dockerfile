FROM restreamio/gstreamer:dev-downloaded

ARG WEBKIT_USE_SCCACHE=0

ENV DEBUG=true
ENV OPTIMIZATIONS=true

RUN ["/compile"]

FROM restreamio/gstreamer:prod-base

COPY --from=0 /compiled-binaries /