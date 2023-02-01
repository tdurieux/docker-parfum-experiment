FROM prestashop/prestashop-git:latest

# To run files with the same group as your primary user
ARG GROUP_ID
ARG USER_ID

RUN groupmod -g $GROUP_ID www-data \
  && usermod -u $USER_ID -g $GROUP_ID www-data

COPY .docker/wait-for-it.sh /tmp/
COPY .docker/docker_run_git.sh /tmp/

RUN mkdir -p /var/www/.npm
RUN chown -R www-data:www-data /var/www/.npm
RUN mkdir -p /var/www/.composer
RUN chown -R www-data:www-data /var/www/.composer

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install mailutils to make sendmail work
RUN apt install --no-install-recommends -y \
    apt-utils \
    mailutils && rm -rf /var/lib/apt/lists/*;

CMD ["/tmp/docker_run_git.sh"]
