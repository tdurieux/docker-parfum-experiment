# Usage:
#
#   $ docker build . -t csd
#   $ docker run -v $(pwd):/app -ti csd rake test

ARG RUBY_VERSION=2.7.2

FROM circleci/ruby:2.7.2-node-browsers

RUN \
  # Install dependencies
  sudo apt-get update && \
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
    automake \
    build-essential \
    curl \
    fftw3-dev \
    gettext \
    gobject-introspection \
    gtk-doc-tools \
    libexif-dev \
    libfftw3-dev \
    libgif-dev \
    libglib2.0-dev \
    libgsf-1-dev \
    libgtk2.0-dev \
    libmagickwand-dev \
    libmatio-dev \
    libopenexr-dev \
    libopenslide-dev \
    liborc-0.4-dev \
    libpango1.0-dev \
    libpoppler-glib-dev \
    librsvg2-dev \
    libtiff5-dev \
    libwebp-dev \
    libxml2-dev \
    swig


WORKDIR /app
RUN sudo chmod a+w -R /app

ADD ./bin/install-vips /app/bin/
RUN sudo /app/bin/install-vips

ADD ./lib/capybara/screenshot/diff/version.rb /app/lib/capybara/screenshot/diff/
ADD ./capybara-screenshot-diff.gemspec /app/
ADD ./gems.rb /app/

RUN bundle install

RUN \
  # Clean up
  sudo apt-get remove -y curl automake build-essential && \
  sudo apt-get autoremove -y && \
  sudo apt-get autoclean && \
  sudo apt-get clean && \
  sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

