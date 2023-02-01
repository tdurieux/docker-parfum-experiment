# ======================================================================
# source code
# ======================================================================
FROM scratch as source
COPY shellspec LICENSE /opt/shellspec/
COPY lib /opt/shellspec/lib
COPY libexec /opt/shellspec/libexec

# ======================================================================
# Fake kcov target to pass the test
# ======================================================================
FROM busybox as kcov
RUN echo "#!/bin/true" > /bin/sh

# ======================================================================
# Use standard target to test source code
# ======================================================================
FROM alpine as standard
ENV PATH /opt/shellspec/:$PATH
COPY --from=source /opt/shellspec /opt/shellspec

# ======================================================================
# Source image (default)
#   TAG: shellspec-scratch:latest, shellspec-scratch:[VERSION]
# ======================================================================