FROM centos:8

RUN rpm --import https://packages.treasuredata.com/GPG-KEY-td-agent \
      && printf "[treasuredata]\nname=TreasureData\nbaseurl=http://packages.treasuredata.com/4/redhat/\$releasever/\$basearch\ngpgcheck=1\ngpgkey=https://packages.treasuredata.com/GPG-KEY-td-agent\n" > /etc/yum.repos.d/td.repo \
      && yum install -y td-agent make gcc-c++ systemd && rm -rf /var/cache/yum

ENV PATH /opt/td-agent/bin/:$PATH
RUN td-agent-gem install bundler
WORKDIR /usr/local/src
COPY Gemfile ./
COPY fluent-plugin-systemd.gemspec ./
RUN bundle install
COPY . .
RUN bundle exec rake test TESTOPTS="-v"
