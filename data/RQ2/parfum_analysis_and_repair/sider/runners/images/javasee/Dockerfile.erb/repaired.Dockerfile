FROM sider/devon_rex_java:2.46.0

<%= render_erb 'images/Dockerfile.base.erb' %>

ARG JAVASEE_VERSION=0.2.0

RUN mkdir /tmp/work && \
    cd /tmp/work && \
    curl -fsSLO --compressed "https://github.com/sider/JavaSee/releases/download/${JAVASEE_VERSION}/JavaSee-bin-${JAVASEE_VERSION}.zip" && \
    unzip "JavaSee-bin-${JAVASEE_VERSION}.zip" && \
    mkdir "${RUNNER_USER_HOME}/JavaSee" && \
    cp -rv "JavaSee-bin-${JAVASEE_VERSION}/bin" "${RUNNER_USER_HOME}/JavaSee/bin" && \
    cp -rv "JavaSee-bin-${JAVASEE_VERSION}/lib" "${RUNNER_USER_HOME}/JavaSee/lib" && \
    ln -sv "${RUNNER_USER_HOME}/JavaSee/bin/javasee" "${RUNNER_USER_BIN}/javasee" && \
    cd .. && \
    rm -rf /tmp/work && \
    javasee version | grep "${JAVASEE_VERSION}"

<%= render_erb 'images/Dockerfile.end.erb' %>