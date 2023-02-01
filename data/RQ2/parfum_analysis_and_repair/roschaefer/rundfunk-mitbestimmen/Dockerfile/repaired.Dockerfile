FROM rundfunk-mitbestimmen-backend

RUN yum install -y libX11 && rm -rf /var/cache/yum
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y chromium && rm -rf /var/cache/yum

WORKDIR /fullstack

RUN mv /backend  /fullstack/backend

ADD Gemfile      /fullstack/Gemfile
ADD Gemfile.lock /fullstack/Gemfile.lock
ADD features     /fullstack/features

RUN bundle install

