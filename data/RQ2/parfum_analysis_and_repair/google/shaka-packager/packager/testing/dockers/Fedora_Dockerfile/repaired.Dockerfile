FROM fedora:34

# Install utilities, libraries, and dev tools.
RUN yum install -y \
        which \
        c-ares-devel libatomic \
        gcc-c++ git python2 && rm -rf /var/cache/yum

# Default to python2 because our build system is ancient.
RUN ln -sf python2 /usr/bin/python

# Install depot_tools.
WORKDIR /
RUN git clone -b chrome/4147 https://chromium.googlesource.com/chromium/tools/depot_tools.git
RUN touch depot_tools/.disable_auto_update
ENV PATH /depot_tools:$PATH

# Bypass VPYTHON included by depot_tools.  Prefer the system installation.
ENV VPYTHON_BYPASS="manually managed python not supported by chrome operations"

# Build and run this docker by mapping shaka-packager with
# -v "shaka-packager:/shaka-packager".
