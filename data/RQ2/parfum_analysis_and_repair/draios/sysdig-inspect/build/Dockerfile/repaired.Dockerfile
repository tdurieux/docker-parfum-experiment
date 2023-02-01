FROM debian:stable-slim



###############################################################################
#                                                                             #
# Install basic tools/utilities                                               #
#                                                                             #
###############################################################################

RUN apt-get update -qq && \
    apt-get dist-upgrade -u -y && \
    apt-get install --no-install-recommends -y \
      curl \
      rpm \
      zip \
      unzip && \
    apt-get install -y -f && rm -rf /var/lib/apt/lists/*;

# Install Node.js v10
# (ref. https://github.com/nodesource/distributions/blob/master/README.md#installation-instructions)
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install the latest Docker CE binaries
# From https://github.com/getintodevops/jenkins-withdocker/blob/master/Dockerfile
RUN apt-get install --no-install-recommends -y \
      apt-transport-https \
      ca-certificates \
      gnupg2 \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; rm -rf /var/lib/apt/lists/*; apt-key add /tmp/dkey && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" && \
   apt-get update -qq && \
   apt-get install --no-install-recommends -y docker-ce

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



###############################################################################
#                                                                             #
# Prepare environment                                                         #
#                                                                             #
###############################################################################

WORKDIR /usr/bin/sysdig-inspect

# Electron runs sudo bower, which is not allowed. See https://serverfault.com/a/755902
RUN echo '{ "allow_root": true }' > ~/.bowerrc



###############################################################################
#                                                                             #
# Run the build                                                               #
#                                                                             #
###############################################################################

CMD ["./build/build.sh"]
