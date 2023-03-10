FROM ruby:2.7-alpine

# This Dockerfile is much lighter but won't work with gke whitelisting. Getting this error when the google gke sdk is called:
#
#    Error loading shared library ld-linux-x86-64.so.2: No such file or directory #986
#
# If you don't need gke whitelisting, then this image should work and is lighter.

RUN apk add --no-cache docker
RUN apk add --no-cache build-base ruby ruby-dev

RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/amd64/kubectl
RUN chmod u+x kubectl && mv kubectl /bin/kubectl

WORKDIR /app
ADD . /app
RUN bundle install
RUN rake install

ENTRYPOINT ["/usr/local/bundle/bin/kubes"]