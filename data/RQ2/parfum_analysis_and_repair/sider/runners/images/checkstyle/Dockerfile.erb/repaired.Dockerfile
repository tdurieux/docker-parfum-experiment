<%= render_erb 'images/Dockerfile.java.erb' %>

COPY --chown=<%= chown %> images/<%= analyzer %>/checkstyle ${RUNNER_USER_BIN}/
COPY --chown=<%= chown %> images/<%= analyzer %>/sider_recommended_checkstyle.xml ${RUNNER_USER_HOME}/

<%= render_erb 'images/Dockerfile.end.erb' %>