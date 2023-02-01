FROM ruby:2.3.6
MAINTAINER Serge Tkatchouk <sp1j3t@gmail.com>

# Assume that we run in production by default:
ENV RAILS_ENV=production

# Pull the app:
WORKDIR /srv/kofta
COPY . /srv/kofta
COPY config/examples /srv/kofta/config/

# Prepare the userland:
RUN apt-get update && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && \
    bundle install --jobs=$(nproc) --without development test && \
    rake assets:precompile && \
    # Remove build-related stuff: \
    apt-get -y purge build-essential && \
    apt-get -y autoremove && apt-get -y clean && \
    
# Expose the We && rm -rf /var/lib/apt/lists/*;

# Run Kofta app:
CMD bundle exec rails server -b '0.0.0.0' -p '3000'
