FROM ubuntu:trusty

RUN apt-get update -y && apt-get install --no-install-recommends -y --force-yes \
    ruby \
    ruby1.9.1-dev \
    git \
    man \
    mc \
    wget \
    make && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp; wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.5_x86_64.deb
RUN dpkg --install /tmp/vagrant_1.6.5_x86_64.deb
RUN gem install bundler

RUN cd /tmp; git clone https://github.com/mitchellh/vagrant-aws.git
RUN cd /tmp/vagrant-aws && bundle install
RUN cd /tmp/vagrant-aws && rake install
RUN cd /tmp/vagrant-aws && VAGRANT_FORCE_BUNDLER=1 vagrant plugin install pkg/vagrant-aws-0.5.1.gem
RUN vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box


CMD /bin/true

