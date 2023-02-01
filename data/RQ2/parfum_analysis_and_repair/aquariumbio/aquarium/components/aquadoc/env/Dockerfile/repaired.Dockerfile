FROM ubuntu:20:10

RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-utils && \
    apt-get install --no-install-recommends -y ruby-full && \
    apt-get install --no-install-recommends -y curl && \
    apt-get install --no-install-recommends -y nano && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN gem install octokit
RUN gem install specific_install
RUN gem specific_install https://github.com/klavinslab/aquadoc

WORKDIR /home
