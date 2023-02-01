FROM seapy/rails-nginx-unicorn-pro:v1.0-ruby2.1.2-nginx1.6.0
MAINTAINER seapy(iamseapy@gmail.com)

# Add here your preinstall lib(e.g. imagemagick, mysql lib, pg lib, ssh config)
## Install imagemagick
RUN apt-get update
RUN apt-get -qq --no-install-recommends -y install libmagickwand-dev imagemagick && rm -rf /var/lib/apt/lists/*;
## Install for mysql gem
RUN apt-get install --no-install-recommends -qq -y mysql-server mysql-client libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;
## Install for Webshots
RUN apt-get install --no-install-recommends libssl0.9.8 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends ttf-unfonts-core -y && rm -rf /var/lib/apt/lists/*;

#(required) Install Rails App
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test
ADD . /app

# Overwrite unicorn
ADD config/unicorn.rb /app/config/unicorn.rb

#(required) nginx port number
EXPOSE 80
