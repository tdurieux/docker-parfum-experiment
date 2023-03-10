FROM alpine:3.11

# Install utilities, libraries, and dev tools.
RUN apk add --no-cache \
        bash curl \
        bsd-compat-headers c-ares-dev linux-headers \
        build-base git ninja python2 python3

# Default to python2 because our build system is ancient.
RUN ln -sf python2 /usr/bin/python

# Install depot_tools.
WORKDIR /
RUN git clone -b chrome/4147 https://chromium.googlesource.com/chromium/tools/depot_tools.git
RUN touch depot_tools/.disable_auto_update
ENV PATH $PATH:/depot_tools

# Bypass VPYTHON included by depot_tools.  Prefer the system installation.
ENV VPYTHON_BYPASS="manually managed python not supported by chrome operations"

# Alpine uses musl which does not have mallinfo defined in malloc.h. Define the
# structure to workaround a Chromium base bug.
RUN sed -i \
    '/malloc_usable_size/a \\nstruct mallinfo {\n  int arena;\n  int hblkhd;\n  int uordblks;\n};' \
    /usr/include/malloc.h
ENV GYP_DEFINES='musl=1'

# Build and run this docker by mapping shaka-packager with
# -v "shaka-packager:/shaka-packager".