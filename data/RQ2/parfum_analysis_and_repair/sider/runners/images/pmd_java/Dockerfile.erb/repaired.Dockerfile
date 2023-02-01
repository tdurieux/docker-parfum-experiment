<%= render_erb 'images/Dockerfile.java.erb' %>

COPY --chown=<%= chown %> images/<%= analyzer %>/pmd ${RUNNER_USER_BIN}/
COPY --chown=<%= chown %> images/<%= analyzer %>/sider_recommended_pmd.xml ${RUNNER_USER_HOME}/

<%= render_erb 'images/Dockerfile.end.erb' %>