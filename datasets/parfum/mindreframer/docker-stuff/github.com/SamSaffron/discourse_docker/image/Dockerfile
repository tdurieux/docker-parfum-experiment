# DOCKER-VERSION 0.6.7

# 13.10 - 04 has a missing ppa for postgresql 9.2 at the moment (26/10/2013)
FROM samsaffron/discourse_base:0.1.1

MAINTAINER Sam Saffron "https://twitter.com/samsaffron"

# Discourse specific bits
RUN useradd discourse -s /bin/bash -m -U &&\
    mkdir /var/www && cd /var/www &&\
     git clone --depth 1 https://github.com/discourse/discourse.git &&\
     chown -R discourse:discourse /var/www/discourse && cd / &&\
    cd /var/www/discourse &&\
     sudo -u discourse RAILS4=1 bundle install --deployment \
         --without test --without development &&\
    cd /var/www/discourse/vendor/bundle &&\
       find . -name tmp -type d | xargs rm -rf && cd /


# For a smaller but less flexible image:
#RUN apt-get -y autoremove build-essential gcc gcc-4.7 .+-dev
#RUN echo image size: $(du -hsx /)

# RUN cd /var/www/discourse && bundle exec rake db:test:prepare && bundle exec rspec

# mkdir -p /src/godeb && cd /src/godeb && curl -O https://godeb.s3.amazonaws.com/godeb-amd64.tar.gz &&\
# cd /src/godeb && tar -xzvf godeb-amd64.tar.gz &&\
# cd /src/godeb && ./godeb install &&\
# cd /src &&  git clone https://github.com/coreos/etcd.git &&\
# cd /src/etcd && ./build &&\
# cp /src/etcd/etcd /usr/local/bin &&\
# add-apt-repository ppa:chris-lea/node.js &&\
