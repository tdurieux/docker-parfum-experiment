FROM gitlab/gitlab-ce:{TAG}

ENV GITLAB_VERSION={BRANCH}

RUN set -xe \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -yqq locales tzdata \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
ENV TZ=Asia/Shanghai

ENV GITLAB_DIR=/opt/gitlab/embedded/service/gitlab-rails
ENV GITLAB_ZH_GIT=https://gitlab.com/xhang/gitlab.git

RUN set -xe \
    && echo " # Preparing ..." \
    && export DEBIAN_FRONTEND=noninteractive \
    && export SSL_CERT_DIR=/etc/ssl/certs/ \
    && export GIT_SSL_CAPATH=/etc/ssl/certs/ \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && export buildDeps='lsb-release patch nodejs python build-essential yarn cmake' \
    && apt-get install -yqq $buildDeps \
    && echo " # Generating translation patch ..." \
    && cd /tmp \
    && git clone ${GITLAB_ZH_GIT} gitlab \
    && cd gitlab \
    && export REVISION=$(cat ${GITLAB_DIR}/REVISION) \
    && export IGNORE_DIRS=':!spec :!features :!.gitignore :!locale :!app/assets/javascripts/locale' \
    && git diff --diff-filter=d {VERSION}..origin/{BRANCH} -- . ${IGNORE_DIRS} > ../zh_CN.diff \
    && echo " # Patching ..." \
    && patch -d ${GITLAB_DIR} -p1 < ../zh_CN.diff \
    && echo " # Copy locale files ..." \
    && cp -R locale ${GITLAB_DIR}/ \
    && echo " # Install missing Gem packages ..." \
    && cd ${GITLAB_DIR} \
    && bundle install \
    && echo " # Regenerating the assets" \
    && cd ${GITLAB_DIR} \
    && cp config/gitlab.yml.example config/gitlab.yml \
    && cp config/database.yml.postgresql config/database.yml \
    && cp config/secrets.yml.example config/secrets.yml \
    && rm -rf public/assets \
    && rm -rf yarn.lock node_modules \
    && yarn install \
    && RAILS_ENV=production \
        NO_PRIVILEGE_DROP=true \
        USE_DB=false \
        SKIP_STORAGE_VALIDATION=true \
        bundle exec rake gitlab:assets:compile \
    && rm -rf log \
        tmp \
        config/gitlab.yml \
        config/database.yml \
        config/secrets.yml \
        .secret \
        .gitlab_shell_secret \
        .gitlab_workhorse_secret \
        node_modules \
    && echo " # Cleaning ..." \
    && yarn cache clean \
    && apt-get purge -y --auto-remove \
        -o APT::AutoRemove::RecommendsImportant=false \
        -o APT::AutoRemove::SuggestsImportant=false \
        $buildDeps \
    && find /usr/lib/ -name __pycache__ | xargs rm -rf \
    && rm -rf /tmp/gitlab /tmp/*.diff /root/.cache /var/lib/apt/lists/*
