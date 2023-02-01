<%= render_erb 'images/Dockerfile.npm.erb' %>

COPY --chown=<%= chown %> \
     images/<%= analyzer %>/sider_jshintignore \
     images/<%= analyzer %>/sider_jshintrc \
     images/<%= analyzer %>/custom-json-reporter.js \
     ${RUNNER_USER_HOME}/

<%= render_erb 'images/Dockerfile.end.erb' %>