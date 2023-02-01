<%= render_erb 'images/Dockerfile.npm.erb' %>

COPY --chown=<%= chown %> \
     images/<%= analyzer %>/sider_recommended_eslint.js \
     images/<%= analyzer %>/custom-eslint-json-formatter.js \
     ${RUNNER_USER_HOME}/

<%= render_erb 'images/Dockerfile.end.erb' %>