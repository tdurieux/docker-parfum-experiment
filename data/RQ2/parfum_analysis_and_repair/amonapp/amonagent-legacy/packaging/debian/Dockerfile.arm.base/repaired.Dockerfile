FROM mazzolino/armhf-debian:wheezy

RUN apt-get update && apt-get install --no-install-recommends -y --force-yes ruby ruby-dev gcc make python python-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install fpm --no-ri --no-rdoc
RUN uname -a

CMD ["/bin/bash"]