# Dockerfile # Mapknitter
# https://github.com/publiclab/mapknitter/
# This image deploys Mapknitter!

FROM ruby:2.7.6

# Set correct environment variables.
ENV HOME /root

# We bring our own key to verify our packages
COPY sysadmin.publiclab.key /app/sysadmin.publiclab.key
RUN apt-key add /app/sysadmin.publiclab.key > /dev/null 2>&1

# Install dependencies for Mapknitter
RUN apt-get update -qq && apt-get install --allow-unauthenticated -y --no-install-recommends \
  nodejs curl procps git imagemagick && rm -rf /var/lib/apt/lists/*;

# Configure ImageMagick
COPY ./nolimit.xml /etc/ImageMagick-6/policy.xml

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;

# See https://github.com/instructure/canvas-lms/issues/1404#issuecomment-461023483 and
# https://github.com/publiclab/mapknitter/pull/803
RUN git config --global url."https://".insteadOf git://

# Install bundle of gems
# Add the Rails app
COPY . /app/
WORKDIR /app

RUN apt-get clean && \
    apt-get autoremove -y

ENV BUNDLER_VERSION=2.1.4
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem install --default bundler && \
    gem update --system && \
    bundle install && rm -rf /root/.gem;

CMD [ "sh", "/app/start.sh" ]
