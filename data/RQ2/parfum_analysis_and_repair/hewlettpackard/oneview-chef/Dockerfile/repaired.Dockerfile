# See examples/README.md to see how to build and run this

FROM ubuntu:18.04

# Uncomment & edit the next 3 lines if you're behind a proxy:
# ENV http_proxy="http://proxy.example.com:8080"
# ENV https_proxy=${http_proxy}
# ENV no_proxy="localhost,127.0.0.1"

# Install chef-client
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -y && \
    apt-get install -y --no-install-recommends --no-upgrade && \
    apt-get install --no-install-recommends -y ca-certificates curl git vim bash openssl && \
    apt-get install --no-install-recommends -y ruby-dev && \
    apt-get install --no-install-recommends -y gcc make && \
    curl -f -L --progress-bar https://www.chef.io/chef/install.sh | bash -s -- -v 13.12.3 && rm -rf /var/lib/apt/lists/*;

# Some optional but recommended packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends --no-upgrade \
    git \
    vim \
    unzip && rm -rf /var/lib/apt/lists/*;

RUN gem install oneview-sdk # Ignore the warning about the path not containing gem executables

RUN mkdir -p /chef-repo/.chef/
RUN mkdir -p /chef-repo/cookbooks
WORKDIR /chef-repo
RUN echo 'cookbook_path ["#{File.dirname(__FILE__)}/../cookbooks"]' > .chef/knife.rb
WORKDIR /chef-repo/cookbooks/
RUN knife cookbook site download compat_resource --force
RUN tar -xzf compat_resource-*.tar.gz && rm compat_resource*.tar.gz
ADD . oneview/
WORKDIR /chef-repo/cookbooks/oneview/
ENV ONEVIEWSDK_SSL_ENABLED=false

# Clean and remove not required packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/cache/apt/archives/* /var/cache/apt/lists/* /tmp/* /root/cache/.

#Install gem and its dependencies
RUN gem install bundler --force
RUN apt-get -y --no-install-recommends install patch build-essential zlib1g-dev liblzma-dev && rm -rf /var/lib/apt/lists/*;
RUN bundle update

CMD "/bin/bash"

# When you run this image, you'll need to set the following environment variables:
# ONEVIEWSDK_URL
# ONEVIEWSDK_USER
# ONEVIEWSDK_PASSWORD

# And if you're running Image Streamer examples, you'll need to set this too:
# I3S_URL