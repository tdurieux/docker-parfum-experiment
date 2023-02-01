<%= render_erb 'images/Dockerfile.php.erb' %>

# Set install paths
RUN basepath="${COMPOSER_HOME}/vendor" && \
    phpcs --config-set installed_paths \
      "${basepath}/cakephp/cakephp-codesniffer,${basepath}/escapestudios/symfony2-coding-standard,${basepath}/wp-coding-standards/wpcs" && \
    phpcs -i

COPY --chown=<%= chown %> images/<%= analyzer %>/sider_recommended_code_sniffer.xml ${RUNNER_USER_HOME}/

<%= render_erb 'images/Dockerfile.end.erb' %>