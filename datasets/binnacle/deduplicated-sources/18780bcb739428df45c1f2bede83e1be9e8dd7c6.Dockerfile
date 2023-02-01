FROM centos:7.1.1503

RUN yum remove -y fakesystemd \
      && rpm --import https://packages.treasuredata.com/GPG-KEY-td-agent \
      && printf "[treasuredata]\nname=TreasureData\nbaseurl=http://packages.treasuredata.com/2/redhat/\$releasever/\$basearch\ngpgcheck=1\ngpgkey=https://packages.treasuredata.com/GPG-KEY-td-agent\n" > /etc/yum.repos.d/td.repo \
      && yum install -y td-agent make gcc-c++ systemd

ENV PATH /opt/td-agent/embedded/bin/:$PATH
RUN fluent-gem install bundler
WORKDIR /usr/local/src
COPY Gemfile ./
COPY fluent-plugin-systemd.gemspec ./
RUN bundle install
COPY . .
RUN rake test TESTOPTS="-v"