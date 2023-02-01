<%= render_erb 'images/Dockerfile.ruby.erb' %>

COPY --chown=<%= chown %> images/<%= analyzer %>/v5.reek.yml ${RUNNER_USER_HOME}/.reek.yml
COPY --chown=<%= chown %> images/<%= analyzer %>/v4.reek.yml ${RUNNER_USER_HOME}/config.reek

<%= render_erb 'images/Dockerfile.end.erb' %>