FROM openbuildservice/base

RUN /root/bin/docker-bootstrap.sh frontend

# Install other requirements
RUN npm install -g jshint

# Ensure there are ruby, gem and irb commands without ruby suffix
RUN for i in ruby gem irb; do ln -s /usr/bin/$i.ruby2.5 /usr/local/bin/$i; done

# foreman, which we only run in docker, needs a different thor version than OBS.
# Installing the gem directly spares us from having to rpm package two different thor versions.
RUN gem.ruby2.5 install --no-format-executable thor:0.19 foreman mailcatcher

# We copy the Gemfiles into this intermediate build stage so it's checksum
# changes and all the subsequent stages (a.k.a. the bundle install call below)
# have to be rebuild. Otherwise, after the first build of this image,
# docker would use it's cache for this and the following stages.
ADD Gemfile /obs/src/api/Gemfile
ADD Gemfile.lock /obs/src/api/Gemfile.lock
RUN chown -R frontend /obs/src/api

# Now do the rest as the user with the same ID as the user who
# builds this container
USER frontend
WORKDIR /obs/src/api

# We install our bundle here as kind of a cache. So developers, that often
# rebuild their frontend image which is based on this, don't have to install
# _all_ gems _all_ the time. We keep this cache warm by automatically
# rebuilding this image every time there is a commit to master. See
# https://hub.docker.com/r/openbuildservice/frontend-base/builds/
RUN export NOKOGIRI_USE_SYSTEM_LIBRARIES=1; bundle install --jobs=3 --retry=3 || bundle install --jobs=3 --retry=3

# Switch to root again so we don't block changing our frontend user id...
USER root

# Run our command
CMD ["/bin/bash", "-l"]
