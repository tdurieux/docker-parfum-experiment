FROM %BASE

# Set and create GOPATH directories.
ENV GOPATH /home/user/go
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

ADD install_go_tools.sh /tmp/
RUN bash /tmp/install_go_tools.sh

ENV GO111MODULE=on

# This technically has no effect until #35 is resolved.
RUN installext ms-vscode.go

LABEL share.go_mod "~/go/pkg/mod:~/go/pkg/mod"
LABEL project_root "~/go/src/"