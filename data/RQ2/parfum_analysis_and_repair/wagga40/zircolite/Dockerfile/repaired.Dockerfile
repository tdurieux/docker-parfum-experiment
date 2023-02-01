# Since `evtx_dump` precompiled binaries are not shipped with musl support, we need to use the
# Debian-based Python image instead of the Alpine-based image, which increases the size of the
# final image (~70 MB overhead).
#