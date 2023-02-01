FROM sider/devon_rex_python:2.46.0

<%= render_erb 'images/Dockerfile.base.erb' %>

# Install the default version
COPY --chown=<%= chown %> images/<%= analyzer %>/Pipfile ${RUNNERS_DEPS_DIR}/
RUN cd "${RUNNERS_DEPS_DIR}" && \
    pipenv install --system --skip-lock && \
    rm Pipfile