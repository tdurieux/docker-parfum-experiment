FROM debian
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get install --no-install-recommends -yq build-essential ruby ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq libxml2-dev libxslt-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install nokogiri -- --use-system-libraries
RUN gem install aws-sdk
