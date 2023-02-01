# docker build --rm -t saltstack/drone-salt-jenkins-testing -f Dockerfile.drone-builds .
FROM docker:edge-dind

COPY Gemfile /Gemfile

RUN apk --update add \
  wget python python-dev py-pip git ruby-bundler ruby-rdoc ruby-dev gcc make libc-dev openssl-dev libffi-dev && \
  gem install bundler && \
  bundle install --gemfile=/Gemfile --with docker --without opennebula ec2 windows vagrant && \
  rm -rf /Gemfile /root/.cache

VOLUME /var/lib/docker
EXPOSE 2375

ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]
CMD []
