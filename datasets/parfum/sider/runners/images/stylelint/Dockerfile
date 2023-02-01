# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_npm:2.46.0


ENV RUNNERS_DEPS_DIR ${RUNNER_USER_HOME}/dependencies
ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners

# Install required gems first (due to slow download)
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} Gemfile Gemfile.lock runners.gemspec analyzers.yml ${RUNNERS_DIR}/
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib/runners/version.rb ${RUNNERS_DIR}/lib/runners/

RUN cd "${RUNNERS_DIR}" && \
    bundle config set --global jobs 4 && \
    bundle config set --global retry 3 && \
    bundle config && \
    BUNDLE_WITHOUT=development bundle install && \
    bundle list && \
    echo 'Checking if the Bundler version is expected...' && \
    lockfile_bundler_version=$(bundle exec ruby -e 'puts Bundler.locked_gems.bundler_version') && \
    bundle version | grep "Bundler version ${lockfile_bundler_version}"

# Install the default version
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/stylelint/package.json ${RUNNERS_DEPS_DIR}/
RUN cd "${RUNNERS_DEPS_DIR}" && \
    npm install --strict-peer-deps --ignore-scripts --engine-strict --no-progress --no-save && \
    rm package*.json && \
    # We can't use NODE_PATH
    # See the details here: https://github.com/sider/runners/issues/2636
    ln -s "${RUNNERS_DEPS_DIR}"/node_modules "${RUNNER_USER_HOME}"
ENV PATH ${RUNNERS_DEPS_DIR}/node_modules/.bin:${PATH}

# NOTE: Install the older version to run `stylelint-config-recommended` with stylelint v8.
RUN cd "${RUNNER_USER_HOME}" && \
    mkdir stylelint-config-recommended.old && \
    cd stylelint-config-recommended.old && \
    npm init -y && \
    npm install stylelint-config-recommended@2 && \
    rm package*.json

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} \
     images/stylelint/sider_recommended_config.old.yaml \
     images/stylelint/sider_recommended_config.yaml \
     images/stylelint/sider_recommended_stylelintignore \
     ${RUNNER_USER_HOME}/


# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} exe ${RUNNERS_DIR}/exe
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/exe:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

COPY images/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh", "runners", "--analyzer=stylelint"]
