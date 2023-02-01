# Instructions
# ------------
#
# Build the Docker image using:
#
#   docker build -t test-gir_ffi .
#
# You can pick any image name instead of test-gir_ffi, of course. After the
# build is done, run bash interactively inside the image like so:
#
#   docker run -v $PWD:/gir_ffi --rm -it test-gir_ffi:latest bash
#
# The `-v $PWD:/gir_ffi` will make the container pick up any changes to the
# code, so you can edit and re-run the tests.

FROM ruby:2.5

RUN apt-get update
# Provides libgirepository-1.0.so.1
RUN apt-get install --no-install-recommends -y libgirepository-1.0-1 && rm -rf /var/lib/apt/lists/*;
# Provides source code for test libraries and tools to generate introspection data
RUN apt-get install --no-install-recommends -y gobject-introspection && rm -rf /var/lib/apt/lists/*;
# Provides gir files for various libraries, needed for generating gir files
# for test libraries
RUN apt-get install --no-install-recommends -y libgirepository1.0-dev && rm -rf /var/lib/apt/lists/*;
# The following packages provide typelibs for various libraries
RUN apt-get install --no-install-recommends -y gir1.2-gtop-2.0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gir1.2-gtk-3.0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gir1.2-pango-1.0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gir1.2-secret-1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gir1.2-gstreamer-1.0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gir1.2-gtksource-3.0 && rm -rf /var/lib/apt/lists/*;

# Ensure Bundler 2.x is installed
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update bundler && rm -rf /root/.gem;

RUN mkdir /gir_ffi
WORKDIR /gir_ffi

# Add just the files needed for running bundle
ADD Gemfile gir_ffi.gemspec Manifest.txt /gir_ffi/
ADD lib/gir_ffi/version.rb /gir_ffi/lib/gir_ffi/version.rb

# Install dependencies
RUN bundle

# Add the full source code
ADD . /gir_ffi
