FROM debian:wheezy

RUN apt-get update && apt-get install --no-install-recommends -y rubygems && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

RUN gem install beanstalkd_view --no-rdoc --no-ri

EXPOSE 5678

CMD ["beanstalkd_view", "--foreground", "--no-launch"]
