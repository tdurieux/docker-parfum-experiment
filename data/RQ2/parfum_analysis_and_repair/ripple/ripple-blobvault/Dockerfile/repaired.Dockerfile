FROM jaesharp/orli-ubuntu-1204-chef-client-d
MAINTAINER Ripple Labs Infrastructure Team "ops@ripplelabs.com"

RUN apt-get -y update && apt-get install --no-install-recommends -y mysql-client && rm -rf /var/lib/apt/lists/*; ADD env/chef /srv/chef
ADD env/dev-env/dev-solo.json /srv/chef/dev-solo.json
ADD env/dev-env/dev-solo.rb  /srv/chef/dev-solo.rb

RUN cd /srv/chef && /opt/chef/embedded/bin/berks install --path /srv/chef/cookbooks
RUN chef-solo -c /srv/chef/dev-solo.rb -j /srv/chef/dev-solo.json


RUN npm install -g supervisor && npm cache clean --force;

RUN mkdir -p /srv/ripple/blobvault
WORKDIR /srv/ripple/blobvault
