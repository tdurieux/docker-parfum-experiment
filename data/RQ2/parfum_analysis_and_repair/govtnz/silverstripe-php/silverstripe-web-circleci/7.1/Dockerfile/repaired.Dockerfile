FROM brettt89/silverstripe-web:7.1-platform
RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    mysql-client \
    vim \
    openjdk-7-jdk \
    openssh-server \
    xvfb \
    libfontconfig \
    wkhtmltopdf && rm -rf /var/lib/apt/lists/*;

# Install composer
RUN curl -f --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir /usr/java && ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/java/default

EXPOSE 8983
EXPOSE 80

CMD ["apache2-foreground"]
