FROM golang:1.14

WORKDIR /app

## install packages
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential libncurses-dev libreadline-dev libssl-dev gnuplot git gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev gawk libsqlite3-dev libtool sqlite3 libgmp-dev && rm -rf /var/lib/apt/lists/*; # ruby build dep

## get source code
RUN git clone https://github.com/hayamiz/perfmonger .

## install RVM
RUN gpg --batch --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -f -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer
RUN curl -f -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer.asc
RUN gpg --batch --verify rvm-installer.asc && rm rvm-installer.asc
RUN bash rvm-installer stable
RUN ln -sf /bin/bash /bin/sh

## install ruby
RUN bash -l -c "rvm install 2.4.9"
RUN bash -l -c "rvm use 2.4.9 && gem install bundler && bundle"

RUN bash -l -c "rvm install 2.5.7"
RUN bash -l -c "rvm use 2.5.7 && gem install bundler && bundle"

RUN bash -l -c "rvm install 2.6.5"
RUN bash -l -c "rvm use 2.6.5 && gem install bundler && bundle"

RUN bash -l -c "rvm install 2.7.0"
RUN bash -l -c "rvm use 2.7.0 && gem install bundler && bundle"

CMD true