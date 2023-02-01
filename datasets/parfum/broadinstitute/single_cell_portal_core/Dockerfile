# use KDUX base Rails image, configure only project-specific items here
FROM gcr.io/broad-singlecellportal-staging/rails-baseimage:2.1.0

# Set ruby version
RUN bash -lc 'rvm --default use ruby-2.6.10'
RUN bash -lc 'rvm rvmrc warning ignore /home/app/webapp/Gemfile'

# Set up project dir, install gems, set up script to migrate database and precompile static assets on run
RUN mkdir /home/app/webapp
RUN sudo chown app:app /home/app/webapp # fix permission issues in local development on MacOSX
RUN gem update --system
RUN gem install bundler
COPY Gemfile /home/app/webapp/Gemfile
COPY Gemfile.lock /home/app/webapp/Gemfile.lock
WORKDIR /home/app/webapp
RUN bundle install
COPY set_user_permissions.bash /etc/my_init.d/01_set_user_permissions.bash
COPY generate_dh_parameters.bash /etc/my_init.d/02_generate_dh_parameters.bash
COPY rails_startup.bash /etc/my_init.d/03_rails_startup.bash

# Configure NGINX
RUN rm /etc/nginx/sites-enabled/default
COPY webapp.conf /etc/nginx/sites-enabled/webapp.conf
COPY nginx.conf /etc/nginx/nginx.conf
RUN rm -f /etc/service/nginx/down

# Compile native support for passenger for Ruby 2.5
RUN passenger-config build-native-support
