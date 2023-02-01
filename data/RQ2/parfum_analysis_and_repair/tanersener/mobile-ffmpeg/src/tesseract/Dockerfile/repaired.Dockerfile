FROM ubuntu
MAINTAINER Ian Blenke <ian@blenke.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git ruby bundler wget unzip && rm -rf /var/lib/apt/lists/*;
RUN gem install travis --no-ri --no-rdoc
RUN git clone https://github.com/travis-ci/travis-build ~/.travis/travis-build
RUN bundle install --gemfile ~/.travis/travis-build/Gemfile

ADD . /tesseract
WORKDIR /tesseract

RUN travis compile | sed -e "s/--branch\\\=\\\'\\\'/--branch=master/g" | bash

