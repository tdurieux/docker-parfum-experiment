FROM dependabot/dependabot-core

RUN useradd -m dependabot
RUN chown -R dependabot:dependabot /usr/local/.pyenv /opt/go/gopath
USER dependabot

RUN mkdir -p /home/dependabot/dependabot-core/common/lib/dependabot
WORKDIR /home/dependabot/dependabot-core

ENV BUNDLE_PATH="/home/dependabot/.bundle" \
    BUNDLE_BIN=".bundle/binstubs" \
    PATH=".bundle/binstubs:$PATH:/home/dependabot/.bundle/bin"

RUN gem install --user rake

COPY common/Gemfile common/dependabot-common.gemspec /home/dependabot/dependabot-core/common/
COPY common/lib/dependabot/version.rb /home/dependabot/dependabot-core/common/lib/dependabot/
RUN cd common && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/terraform
COPY terraform/Gemfile \
     terraform/dependabot-terraform.gemspec \
     /home/dependabot/dependabot-core/terraform/
RUN cd terraform && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/elm
COPY elm/Gemfile \
     elm/dependabot-elm.gemspec \
     /home/dependabot/dependabot-core/elm/
RUN cd elm && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/python
COPY python/Gemfile \
     python/dependabot-python.gemspec \
     /home/dependabot/dependabot-core/python/
RUN cd python && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/docker
COPY docker/Gemfile \
     docker/dependabot-docker.gemspec \
     /home/dependabot/dependabot-core/docker/
RUN cd docker && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/git_submodules
COPY git_submodules/Gemfile \
     git_submodules/dependabot-git_submodules.gemspec \
     /home/dependabot/dependabot-core/git_submodules/
RUN cd git_submodules && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/maven
COPY maven/Gemfile \
     maven/dependabot-maven.gemspec \
     /home/dependabot/dependabot-core/maven/
RUN cd maven && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/gradle
COPY gradle/Gemfile \
     gradle/dependabot-gradle.gemspec \
     /home/dependabot/dependabot-core/gradle/
RUN cd gradle && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/hex
COPY hex/Gemfile \
     hex/dependabot-hex.gemspec \
     /home/dependabot/dependabot-core/hex/
RUN cd hex && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/nuget
COPY nuget/Gemfile \
     nuget/dependabot-nuget.gemspec \
     /home/dependabot/dependabot-core/nuget/
RUN cd nuget && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/composer
COPY composer/Gemfile \
     composer/dependabot-composer.gemspec \
     /home/dependabot/dependabot-core/composer/
RUN cd composer && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/cargo
COPY cargo/Gemfile \
     cargo/dependabot-cargo.gemspec \
     /home/dependabot/dependabot-core/cargo/
RUN cd cargo && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/dep
COPY dep/Gemfile \
     dep/dependabot-dep.gemspec \
     /home/dependabot/dependabot-core/dep/
RUN cd dep && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/go_modules
COPY go_modules/Gemfile \
     go_modules/dependabot-go_modules.gemspec \
     /home/dependabot/dependabot-core/go_modules/
RUN cd go_modules && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/npm_and_yarn
COPY npm_and_yarn/Gemfile \
     npm_and_yarn/dependabot-npm_and_yarn.gemspec \
     /home/dependabot/dependabot-core/npm_and_yarn/
RUN cd npm_and_yarn && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/bundler
COPY bundler/Gemfile \
     bundler/dependabot-bundler.gemspec \
     /home/dependabot/dependabot-core/bundler/
RUN cd bundler && bundle install

RUN mkdir -p /home/dependabot/dependabot-core/omnibus
COPY omnibus/Gemfile \
     omnibus/dependabot-omnibus.gemspec \
     /home/dependabot/dependabot-core/omnibus/
RUN cd omnibus && bundle install

COPY --chown=dependabot . /home/dependabot/dependabot-core/
