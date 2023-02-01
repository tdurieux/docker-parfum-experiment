FROM brettt89/silverstripe-web:7.3-debian-stretch
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/share/man/man1

# RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
	mariadb-client \
    vim \
    openssh-server \
    xvfb \
    libfontconfig \
    wkhtmltopdf && rm -rf /var/lib/apt/lists/*;

# Install java
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && \
    apt-get install --no-install-recommends -y ant && \
    apt-get clean; rm -rf /var/lib/apt/lists/*;

# Install composer
RUN curl -f --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# RUN apt-get install -y openjdk
# The repository 'http://ppa.launchpad.net/openjdk-r/ppa/ubuntu focal Release' does not have a Release file.
# RUN mkdir /usr/java && ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/java/default

EXPOSE 8983
EXPOSE 80

CMD ["apache2-foreground"]
