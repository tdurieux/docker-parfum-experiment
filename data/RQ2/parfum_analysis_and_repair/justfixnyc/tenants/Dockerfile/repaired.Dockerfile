FROM node:4

RUN apt-get update && \
  apt-get install --no-install-recommends -y ruby-full && rm -rf /var/lib/apt/lists/*;

# Newer versions of sass require ruby 2.2, which we're not using, so...
RUN gem install sass -v 3.4.22

ENV PATH /tenants/node_modules/.bin:$PATH
