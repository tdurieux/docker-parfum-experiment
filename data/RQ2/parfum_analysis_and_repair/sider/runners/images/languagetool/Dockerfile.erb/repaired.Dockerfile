FROM sider/devon_rex_java:2.46.0

<%= render_erb 'images/Dockerfile.base.erb' %>

ARG LANGUAGETOOL_VERSION=5.7

RUN cd "${RUNNER_USER_HOME}" && \
    curl -f -sSLO --compressed https://languagetool.org/download/LanguageTool-${LANGUAGETOOL_VERSION}.zip && \
    unzip -q LanguageTool-${LANGUAGETOOL_VERSION}.zip && \
    rm LanguageTool-${LANGUAGETOOL_VERSION}.zip

ENV CLASSPATH ${RUNNER_USER_HOME}/LanguageTool-${LANGUAGETOOL_VERSION}/*:${CLASSPATH}

COPY --chown=<%= chown %> images/<%= analyzer %>/languagetool images/runjava ${RUNNER_USER_BIN}/

<%= render_erb 'images/Dockerfile.end.erb' %>
