# The MIT License (MIT)
#
# Copyright (c) 2018 Vente-Privée
#
# Permission is hereby granted, free of  charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction,  including without limitation the rights
# to use,  copy, modify,  merge, publish,  distribute, sublicense,  and/or sell
# copies  of the  Software,  and to  permit  persons to  whom  the Software  is
# furnished to do so, subject to the following conditions:
#
# The above  copyright notice and this  permission notice shall be  included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE  IS PROVIDED "AS IS",  WITHOUT WARRANTY OF ANY  KIND, EXPRESS OR
# IMPLIED,  INCLUDING BUT  NOT LIMITED  TO THE  WARRANTIES OF  MERCHANTABILITY,
# FITNESS FOR A  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT SHALL THE
# AUTHORS  OR COPYRIGHT  HOLDERS  BE LIABLE  FOR ANY  CLAIM,  DAMAGES OR  OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM vpgrp/debian:latest

ENV DEBIAN_FRONTEND="noninteractive" \
    GO_ARCH="amd64" \
    GO_VERSION="1.10.3" \
    GOPATH="/go" \
    TZ="Europe/Amsterdam"

RUN apt-get update  -qq && \
    apt-get upgrade -qq -y && \
    apt-get install -qq -y \
      curl \
      git \
      libffi-dev \
      make \
      mercurial \
      python \
      python-boto \
      rpm \
      ruby \
      ruby-dev \
      zip

ENV GO_FILE="go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"

RUN curl \
      --fail \
      --location \
      --output /${GO_FILE} \
      --silent \
      --show-error \
      https://dl.google.com/go/${GO_FILE} && \
    tar -C /usr/local/ -xf /${GO_FILE} && \
    rm /${GO_FILE}

ENV PATH="${GOPATH}/bin:${PATH}:/usr/local/go/bin"

WORKDIR /go/src/github.com/vente-privee/influxdb-relay

ENTRYPOINT [ "/go/src/github.com/vente-privee/influxdb-relay/build.py" ]
# EOF
