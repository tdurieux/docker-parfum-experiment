FROM ubuntu:14.04
MAINTAINER wuweixin "wuweixin@gmail.com"
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN gpg --batch --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -f -sSL https://get.rvm.io | bash -s stable --ruby
RUN /bin/bash --login -c "gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/"
RUN /bin/bash --login -c "gem install bundler"
RUN /bin/bash --login -c "bundle config mirror.https://rubygems.org https://ruby.taobao.org"
ADD . /vagrant
WORKDIR /vagrant
RUN /bin/bash --login -c "bundle install"
EXPOSE 3000
ENTRYPOINT /bin/bash --login
