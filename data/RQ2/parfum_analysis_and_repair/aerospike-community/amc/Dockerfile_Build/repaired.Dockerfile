################################################################################
# build/golang:1.7
################################################################################

# Base Image
FROM golang:1.7

# Dependencies
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install grunt -g && npm cache clean --force;

RUN apt-get install --no-install-recommends -y ruby ruby-dev rubygems gcc make && rm -rf /var/lib/apt/lists/*;
RUN gem install --no-ri --no-rdoc fpm
RUN apt-get install --no-install-recommends -y rpm && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y zip tar gzip && rm -rf /var/lib/apt/lists/*;
