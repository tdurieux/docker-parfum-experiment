FROM golang:1.18-bullseye

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y ruby-dev rubygems ruby cmake pkg-config git-core libgit2-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install licensed
