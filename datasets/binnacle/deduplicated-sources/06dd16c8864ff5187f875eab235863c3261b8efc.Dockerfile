FROM ruby:2.4.5

ENV PORT 8080
EXPOSE 8080
WORKDIR /app

# nodejs: for Rails assets
# tzdata: fix TZInfo::DataSourceNotFound on start
# linux-headers: for raindrops that is required by Unicorn
# bash: for debugging in production

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get update -qq \
  && apt-get install -y build-essential nodejs tzdata nginx \
  && rm -rf /var/lib/apt/lists/*

COPY .ruby-version Gemfile* ./

RUN gem install bundler -v "~> 1.3.6" && \
    bundle install --frozen

COPY . ./

# Setup Rails shared folders for Puma / Nginx
RUN mkdir /shared
RUN mkdir /shared/config
RUN mkdir /shared/pids
RUN mkdir /shared/sockets

# Configure Nginx
RUN rm -v /etc/nginx/nginx.conf
RUN rm -v /etc/nginx/sites-enabled/default
ADD config/nginx.conf /etc/nginx/
ADD config/puma.conf /etc/nginx/conf.d/

# Symlink nginx logs to stderr / stdout
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log


RUN bundle exec rake assets:precompile

CMD ["./script/run-puma.sh", "config/puma.config"]
