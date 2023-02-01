FROM sider/devon_rex_base:2.46.0

<%= render_erb 'images/Dockerfile.base.erb' %>

ARG MISSPELL_VERSION=0.3.4

RUN curl -fsSL https://git.io/misspell | bash -s -- -b "${RUNNER_USER_BIN}" "v${MISSPELL_VERSION}" && \
    misspell -v

<%= render_erb 'images/Dockerfile.end.erb' %>