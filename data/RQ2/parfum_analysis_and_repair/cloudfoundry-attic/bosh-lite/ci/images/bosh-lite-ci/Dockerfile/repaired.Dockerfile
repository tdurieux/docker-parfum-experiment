FROM concourse/buildbox-ci

RUN apt-get -y update

# install ruby
RUN apt-get install --no-install-recommends -y ruby ruby-dev && rm -rf /var/lib/apt/lists/*;

# bundler
RUN apt-get install --no-install-recommends -y postgresql-server-dev-9.4 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# s3cmd for pushing assets
RUN apt-get install --no-install-recommends -y python-dateutil && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8BAF9A6F
RUN apt-get update
RUN apt-get install --no-install-recommends -y python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN wget --progress bar:force https://github.com/s3tools/s3cmd/archive/v1.5.0-rc1.tar.gz -O v1.5.0-rc1.tar.gz
RUN tar xvf v1.5.0-rc1.tar.gz && rm v1.5.0-rc1.tar.gz
RUN cd s3cmd-1.5.0-rc1 && python setup.py install
RUN ln -s /usr/local/bin/s3cmd /usr/bin/s3cmd

# jq
RUN apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

# awscli
RUN apt-get -y --no-install-recommends install awscli && rm -rf /var/lib/apt/lists/*;

# for syncing folders via vagrant
RUN apt-get -y --no-install-recommends install rsync && rm -rf /var/lib/apt/lists/*;

# used by nokogiri
RUN apt-get install --no-install-recommends -y libxslt-dev libxml2-dev && rm -rf /var/lib/apt/lists/*;

# vagrant
RUN wget --progress bar:force https://releases.hashicorp.com/vagrant/1.7.4/vagrant_1.7.4_x86_64.deb -O /tmp/vagrant.deb
RUN dpkg -i /tmp/vagrant.deb

# chefdk for vagrant up
RUN wget --progress bar:force https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.4.0-1_amd64.deb -O chefdk_0.4.0-1_amd64.deb
RUN dpkg -i chefdk_0.4.0-1_amd64.deb

# vagrant plugins for building stemcells
ENV HOME /root
RUN vagrant plugin install vagrant-aws --plugin-version 0.5.0

# for making calls to VagrantCloud
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;

# for making Virtualbox's hostonlyifs work since it shells to ifconfig
RUN apt-get -y --no-install-recommends install net-tools && rm -rf /var/lib/apt/lists/*;

# Pre install bundler
RUN gem install bundler -v 1.11.0
