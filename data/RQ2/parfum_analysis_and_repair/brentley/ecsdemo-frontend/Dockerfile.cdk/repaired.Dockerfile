FROM ruby:2.5-slim

COPY Gemfile Gemfile.lock /usr/src/app/
WORKDIR /usr/src/app

RUN apt-get update && apt-get -y --no-install-recommends install iproute2 curl jq libgmp3-dev ruby-dev build-essential sqlite libsqlite3-dev python3 python3-pip && \
    bundle install && \
    pip3 install --no-cache-dir awscli && \
    apt-get autoremove -y --purge && \
    apt-get remove -y --auto-remove --purge ruby-dev libgmp3-dev build-essential libsqlite3-dev && \
    apt-get clean && \
    rm -rvf /root/* /root/.gem* /var/cache/* && rm -rf /var/lib/apt/lists/*;

COPY . /usr/src/app
RUN chmod +x /usr/src/app/startup-cdk.sh

# helpful when trying to update gems -> bundle update, remove the Gemfile.lock, start ruby
# RUN bundle update
# RUN rm -vf /usr/src/app/Gemfile.lock

HEALTHCHECK --interval=10s --timeout=3s \
  CMD curl -f -s http://localhost:3000/health/ || exit 1
EXPOSE 3000
ENTRYPOINT ["bash","/usr/src/app/startup-cdk.sh"]
