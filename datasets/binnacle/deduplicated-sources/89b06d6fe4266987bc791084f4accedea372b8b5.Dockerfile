FROM phusion/passenger-ruby25:1.0.2

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs libreoffice imagemagick unzip ghostscript libsasl2-dev libpq-dev postgresql-client tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# If changes are made to fits version or location,
# amend `LD_LIBRARY_PATH` in docker-compose.yml accordingly.
RUN mkdir -p /opt/fits && \
    curl -fSL -o /opt/fits/fits-latest.zip https://projects.iq.harvard.edu/files/fits/files/fits-1.3.0.zip && \
    cd /opt/fits && unzip fits-latest.zip && chmod +X /opt/fits/fits.sh

RUN rm /etc/nginx/sites-enabled/default
COPY ops/webapp.conf /etc/nginx/sites-enabled/webapp.conf
COPY ops/env.conf /etc/nginx/main.d/env.conf

ENV APP_HOME /home/app/webapp
RUN mkdir $APP_HOME && chown -R app /home/app
WORKDIR $APP_HOME

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=4

COPY  --chown=app Gemfile* $APP_HOME/
RUN /sbin/setuser app bundle install

COPY  --chown=app . $APP_HOME

RUN  /sbin/setuser app /bin/bash -l -c 'cd /home/app/webapp && DB_ADAPTER=nulldb bundle exec rake assets:precompile'

COPY ops/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run
RUN rm -f /etc/service/nginx/down
