#
# Dockerfile for devise-secure_password
#
# prompt> docker build -f Dockerfile.prev -t secure-password-dev-prev .
# prompt> docker run -it secure-password-dev-prev /bin/bash
# prompt> pushd . && cd spec/rails-app-X_y_z
# prompt> gem install bundler && RAILS_TARGET=X.y.z bundle install --jobs 20 --retry 5
# prompt> RAILS_ENV='test' bundle exec rake db:migrate
# prompt> popd
# prompt> gem install bundler && RAILS_TARGET=X.y.z bundle install --jobs 20 --retry 5
# prompt> RAILS_TARGET=X.y.z bundle exec rake test:spec
#
# NOTE: The order in which you run 'bundle install' in spec/rails and then in
# the top directory is important.
#
FROM circleci/ruby:2.4.4-browsers
LABEL maintainer="Mark Eissler <mark.eissler@valimail.com>"

ENV BUILD_HOME='/secure-password-gem'

# Configure the main working directory. This is the base directory used in any
# further RUN, COPY, and ENTRYPOINT commands.
RUN sudo mkdir -p ${BUILD_HOME}
WORKDIR ${BUILD_HOME}

# Copy main application
COPY . ./

# Fix permissions on /gem directory
RUN set -x \
    && sudo chown -R circleci:circleci ${BUILD_HOME}

# Start xvfb automatically
ENV DISPLAY :99

# Update docker-entrypoint.sh