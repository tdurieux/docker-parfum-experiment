#
# Dockerfile-go
#
# Copyright (c) 2016-2017 Junpei Kawamoto
#
# This software is released under the MIT License.
#
# http://opensource.org/licenses/mit-license.php
#
{{define "package"}}
ENV GOPATH /data
RUN apt-get update && \
    apt-get install --no-install-recommends -y golang && \
    rm -rf /var/lib/apt/lists/*

# Install gimme
RUN mkdir -p $GOPATH/bin && \
    curl -f -sL -o $GOPATH/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme && \
    chmod +x $GOPATH/bin/gimme
{{end}}

{{define "version"}}
# Install a specific version of Go
RUN PATH="$GOPATH/bin/:$PATH" && \
    echo "Set Go $VERSION" && \
    [ $VERSION = "any" ] || eval "$(GIMME_GO_VERSION=$VERSION gimme)"
{{end}}

{{define "source"}}
{{if .Travis.GoImportPath}}
ADD {{.Archive}} $GOPATH/src/{{.Travis.GoImportPath}}
{{else}}
ADD {{.Archive}} $GOPATH/src/{{.Repository}}
{{end}}
WORKDIR $GOPATH/src/{{.Repository}}
{{end}}
