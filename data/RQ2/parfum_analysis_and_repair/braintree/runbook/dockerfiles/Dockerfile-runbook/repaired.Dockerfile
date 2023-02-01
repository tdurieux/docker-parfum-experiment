FROM ruby:3.0
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential tmux && rm -rf /var/lib/apt/lists/*;

RUN mkdir /runbook
WORKDIR /runbook

RUN mkdir /runbook/bin
ADD bin/setup /runbook/bin/setup

ADD runbook.gemspec /runbook/runbook.gemspec
ADD Gemfile /runbook/Gemfile

RUN mkdir -p /runbook/lib/runbook
ADD lib/runbook/version.rb /runbook/lib/runbook/version.rb

RUN bin/setup

ADD . /runbook
