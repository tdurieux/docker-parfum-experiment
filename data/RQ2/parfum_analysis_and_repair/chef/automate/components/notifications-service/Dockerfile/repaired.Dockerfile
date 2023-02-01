FROM devchef/elixir:latest
MAINTAINER Chef Software, Inc. <docker@chef.io>

# Install node and npm
RUN apt-get update
RUN apt-get install --no-install-recommends -y node && apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y inotify-tools && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
