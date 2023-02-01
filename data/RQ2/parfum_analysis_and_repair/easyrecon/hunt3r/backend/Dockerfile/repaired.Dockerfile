FROM ruby:3.1.0

RUN apt-get update -qq && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

## Disable SSH host key checking for all hosts
RUN echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN echo "    UserKnownHostsFile" >> /etc/ssh/ssh_config

## Install SCW CLI
RUN wget https://github.com/scaleway/scaleway-cli/releases/download/v2.5.1/scaleway-cli_2.5.1_linux_amd64
RUN mv scaleway-cli_2.5.1_linux_amd64 /usr/local/bin/scw
RUN chmod +x /usr/local/bin/scw

WORKDIR /hunt3r
COPY Gemfile /hunt3r/Gemfile
COPY Gemfile.lock /hunt3r/Gemfile.lock
RUN bundle install