FROM hadolint/hadolint:v2.7.0-debian as hadolint

FROM sider/devon_rex_base:2.46.0

COPY --chown=<%= chown %> --from=hadolint /bin/hadolint ${RUNNER_USER_BIN}/

<%= render_erb 'images/Dockerfile.base.erb' %>
<%= render_erb 'images/Dockerfile.end.erb' %>