<%= render_erb 'images/Dockerfile.ruby.erb' %>

COPY --chown=<%= chown %> images/<%= analyzer %>/sider_recommended_rubocop.yml ${RUNNER_USER_HOME}/

<%= render_erb 'images/Dockerfile.end.erb' %>