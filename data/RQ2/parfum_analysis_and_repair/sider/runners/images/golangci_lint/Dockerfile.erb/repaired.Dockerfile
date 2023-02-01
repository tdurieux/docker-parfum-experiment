FROM golangci/golangci-lint:v1.43.0 as golangci-lint

FROM sider/devon_rex_go:2.46.0

<%= render_erb 'images/Dockerfile.base.erb' %>

COPY --chown=<%= chown %> --from=golangci-lint /usr/bin/golangci-lint ${RUNNER_USER_BIN}/

COPY --chown=<%= chown %> images/<%= analyzer %>/sider_golangci.yml ${RUNNER_USER_HOME}/

# NOTE: Make the `go.mod` file needless (compatible with Go 1.15). See below:
#       - https://golang.org/doc/go1.16#go-command
#       - https://golang.org/ref/mod#mod-commands
ENV GO111MODULE auto

<%= render_erb 'images/Dockerfile.end.erb' %>