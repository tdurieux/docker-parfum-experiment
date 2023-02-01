FROM ruby:2.6
LABEL maintainer="University of Alberta Library"

# Need to add jessie-backports repo so we can get FFMPEG, doesn't come with jessie debian by default
# RUN echo 'deb http://ftp.debian.org/debian jessie-backports main'  >> /etc/apt/sources.list

# Autoprefixer doesn’t support Node v4.8.2. Update it.
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -

## To install the Yarn package manager (rails assets:precompile complains if not installed), run:
RUN curl -f -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y build-essential \
                          libpq-dev \
                          nodejs \
                          yarn \
                          tzdata \
                          # libreoffice \
                          # imagemagick \
                          # ghostscript \
                          # unzip \
                          # ffmpeg \
    && rm -rf /var/lib/apt/lists/*


# install fits
# RUN mkdir -p /usr/local/fits \
#     && cd /usr/local/fits \
#     && wget http://projects.iq.harvard.edu/files/fits/files/fits-1.0.6.zip \
#     && unzip fits-1.0.6.zip \
#     && rm  fits-1.0.6.zip \
#     && chmod a+x /usr/local/fits/fits-1.0.6/fits.sh \
#     && ln -s /usr/local/fits/fits-1.0.6/fits.sh /usr/bin/fits

ENV APP_ROOT /app
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

# Update bundler
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system && rm -rf /root/.gem;
RUN gem install bundler:2.1.4

# Install standard gems
COPY Gemfile* /app/
RUN bundle config --global frozen 1 && \
    bundle install -j4 --retry 3

# *NOW* we copy the codebase in
COPY . $APP_ROOT

# Precompile Rails assets. We set a dummy database url/token key
RUN RAILS_ENV=uat DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname SECRET_KEY_BASE=pickasecuretoken bundle exec rake assets:precompile

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
