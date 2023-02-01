FROM ubuntu/apache2:2.4-20.04_edge

RUN apt-get update

RUN apt-get install --no-install-recommends -y \
  libapache2-mod-php && rm -rf /var/lib/apt/lists/*;

# Add Relay repository
RUN apt-get install --no-install-recommends -y gnupg wget lsb-release software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN wget -q "https://cachewerk.s3.amazonaws.com/repos/key.gpg" -O- | apt-key add -
RUN add-apt-repository "deb https://cachewerk.s3.amazonaws.com/repos/deb $(lsb_release -sc) main"
RUN apt-get update

# Install Relay (match the PHP version Apache is using)
RUN apt-get install --no-install-recommends -y \
  php7.4-relay && rm -rf /var/lib/apt/lists/*;
