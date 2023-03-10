#
# Usage:
#  make build-base
#
# or...
#  docker build -t base --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -f Dockerfile.base .
#

# See https://hub.docker.com/_/ruby
FROM ruby:3.1-slim

# The values will be passed in with --build-arg
ARG USER_ID
ARG GROUP_ID

# Just so they aren't hard coded below
ARG APP_USER=appuser
ARG APP_PATH=/opt/app
ARG APP_LOG_PATH=/var/log/app
ARG CERT_PATH=/opt/certs

RUN \
  #
  # Use the specified id so we can read and write directories outside the container
  addgroup --gid $GROUP_ID $APP_USER && \
  adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID $APP_USER && \
  #
  # Create app dir and app log dir
  mkdir -p $APP_PATH && chown -R $APP_USER:$APP_USER $APP_PATH && \
  mkdir -p $APP_LOG_PATH && chown -R $APP_USER:$APP_USER $APP_LOG_PATH

RUN \


  apt-get update -qq && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
  && \
  #
  # Install the package source for yarn and its signing key
  curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --batch --dearmor > /usr/share/keyrings/yarn-archive-keyring.gpg && \
  echo 'deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main' > \
    /etc/apt/sources.list.d/yarn.list && \
  #
  # Now install some required packages including yarn
  apt-get update -qq && apt-get install -y --no-install-recommends \
    postgresql-client \
    # For webpacker
    nodejs yarn \
    # For editing, e.g. rails secrets
    vim-tiny \
    # Needed at build time to compile gems with native extensions
    gcc g++ make libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN \


  gem update --system --silent --no-document && rm -rf /root/.gem;

# Install script to help start rails
COPY --chown=$APP_USER:$APP_USER ./docker/start-rails.sh /bin

WORKDIR $APP_PATH
USER $APP_USER

# Install some helpful bash aliases for use inside the container
COPY ./docker/dot_bash_aliases /home/$APP_USER/.bash_aliases

# Writes to /home/$APP_USER/.bundle/config
RUN bundle config set --global path '/opt/bundle'

# Make it easy to connect and do things in the container
# See docker-compose for how we start rails
CMD ["/bin/bash"]
