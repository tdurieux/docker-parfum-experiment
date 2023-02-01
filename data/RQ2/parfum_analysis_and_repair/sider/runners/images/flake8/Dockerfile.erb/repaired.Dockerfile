<%= render_erb 'images/Dockerfile.python.erb' %>

COPY --chown=<%= chown %> images/<%= analyzer %>/sider_recommended_flake8.ini ${RUNNER_USER_HOME}/
COPY --chown=<%= chown %> images/<%= analyzer %>/ignored-config.ini ${RUNNER_USER_HOME}/

<%= render_erb 'images/Dockerfile.end.erb' %>