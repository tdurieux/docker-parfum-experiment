FROM centos

RUN mkdir /opt/ruby
RUN yum install -y gcc openssl-devel git tar && yum clean all && rm -rf /var/cache/yum

RUN git clone https://github.com/sstephenson/ruby-build.git /opt/ruby-build && cd /opt/ruby-build && ./install.sh
RUN git clone https://github.com/sstephenson/rbenv.git /opt/rbenv && cd /opt/rbenv && export ver=$(bin/rbenv install -l | grep -P "2.0.0-p\d+" | tail -n1) && bin/rbenv install $ver && bin/rbenv global $ver

ADD ./prepare /usr/bin/
ADD ./run /usr/bin/
ADD ./ruby_context /usr/bin/

EXPOSE 9292

RUN mkdir /opt/ruby/source
RUN chmod +x /usr/bin/prepare /usr/bin/run /usr/bin/ruby_context /usr/bin/save-artifacts

RUN mkdir /opt/ruby/bundle
RUN cd /opt/ruby && /usr/bin/ruby_context gem install bundler --no-rdoc --no-ri
WORKDIR /opt/ruby/source

RUN groupadd -r ruby -g 433 && \
useradd -u 431 -r -g ruby -d /opt/ruby -s /sbin/nologin -c "Ruby user" ruby && \
chown -R ruby:ruby /opt/ruby && \
chown -R ruby:ruby /opt/rbenv

USER ruby
