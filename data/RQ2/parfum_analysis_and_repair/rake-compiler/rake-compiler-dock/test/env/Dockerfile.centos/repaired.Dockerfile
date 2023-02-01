ARG from_image
FROM ${from_image}

RUN uname -a

# Change download address of Centos-8 which is EOL
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum install -y ruby git && rm -rf /var/cache/yum

RUN ruby --version
RUN gem env
RUN gem inst bundler

WORKDIR /build

CMD ruby -e "puts Gem::Platform.local.to_s" && \
  gem install --local *.gem --verbose --no-document && \
  cd test/rcd_test/ && \
  bundle install && \
  rake test
