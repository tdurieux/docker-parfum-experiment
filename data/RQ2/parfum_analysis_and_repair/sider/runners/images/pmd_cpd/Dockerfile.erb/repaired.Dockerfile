<%= render_erb 'images/Dockerfile.java.erb' %>

COPY --chown=<%= chown %> images/pmd_cpd/pmd_cpd ${RUNNER_USER_BIN}/

<%= render_erb 'images/Dockerfile.end.erb' %>