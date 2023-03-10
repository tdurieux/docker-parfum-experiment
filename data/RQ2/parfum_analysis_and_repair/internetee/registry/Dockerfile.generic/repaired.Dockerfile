FROM internetee/ruby_base:3.0
LABEL org.opencontainers.image.source=https://github.com/internetee/registry
ARG YARN_VER='1.22.10'
ARG RAILS_ENV
ARG SECRET_KEY_BASE

ENV RAILS_ENV "$RAILS_ENV"
ENV SECRET_KEY_BASE "$SECRET_KEY_BASE"

RUN npm install -g yarn@"$YARN_VER" && npm cache clean --force;

RUN bash -c 'mkdir -pv -m776 {/opt/webapps/app/tmp/pids,/opt/ca,/opt/ca/newcerts}'
RUN echo -n 12 > /opt/ca/serial
RUN chmod 776 /opt/ca/serial
RUN echo '3A0e' > /opt/ca/crlnumber
RUN chmod 776 /opt/ca/crlnumber
RUN touch /opt/ca/index.txt
RUN chmod 776 /opt/ca/index.txt
WORKDIR /opt/webapps/app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle config set without 'development test' && bundle install --jobs 20 --retry 5
COPY . .

RUN bundle exec rails assets:precompile

EXPOSE 3000
