#
# Builder image
#

FROM golang:1.14.4 AS build-env
ARG SOURCE=*

ADD $SOURCE /src/
WORKDIR /src/

# Unpack any tars, then try to execute a Makefile, but if the SOURCE url is
# just a tar of binaries, then there probably won't be one. Using multiple RUN
# commands to ensure any errors are caught.
RUN find . -name '*.tar.gz' -type f | xargs -rn1 tar -xzf
RUN if [ -f Makefile ]; then make; fi
RUN cp "$(find . -name 'louketo-proxy' -type f -print -quit)" /louketo-proxy

#
# Actual image
#