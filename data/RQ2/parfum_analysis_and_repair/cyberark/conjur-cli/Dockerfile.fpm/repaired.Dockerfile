FROM ubuntu:21.10

RUN apt-get update -y && apt-get install --no-install-recommends -y software-properties-common git build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-add-repository ppa:brightbox/ruby-ng

RUN apt-get update -y && apt-get install --no-install-recommends -y ruby2.2 ruby2.2-dev && rm -rf /var/lib/apt/lists/*;

RUN gem install --no-rdoc --no-ri bundler:1.11.2 fpm

RUN mkdir /conjur-cli

WORKDIR /conjur-cli

COPY . .

ENTRYPOINT [ "./ci/package.sh" ]

