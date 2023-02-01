FROM koalaman/shellcheck:v0.8.0 as shellcheck

FROM sider/devon_rex_base:2.46.0

<%= render_erb 'images/Dockerfile.base.erb' %>

COPY --chown=<%= chown %> --from=shellcheck /bin/shellcheck ${RUNNER_USER_BIN}/

<%= render_erb 'images/Dockerfile.end.erb' %>