# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:latest

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]


##################################################################################################
## CUSTOMIZATION

# Shared volume with the codebase.
VOLUME ["{{ container_dir_for_codebase }}"]

# Install python, pip, git, postgresql client.
RUN apt-get update && apt-get install --no-install-recommends -y python python-pip git postgresql-client-9.3 python-psycopg2 nginx && rm -rf /var/lib/apt/lists/*;

# Create a password file for PostgreSQL (for users root and www-data).
RUN echo "*:*:*:{{ postgresql_username }}:{{ postgresql_password }}" > /root/.pgpass
RUN chmod 0600 /root/.pgpass
RUN mkdir /var/www
RUN echo "*:*:*:{{ postgresql_username }}:{{ postgresql_password }}" > /var/www/.pgpass
RUN chown -R www-data:www-data /var/www
RUN chmod 0600 /var/www/.pgpass

# Copy nginx config file.
COPY nginx-biostar.conf /etc/nginx/sites-available/biostar
RUN ln -s /etc/nginx/sites-available/biostar /etc/nginx/sites-enabled/biostar
RUN rm /etc/nginx/sites-enabled/default

{% if basic_auth_username is defined and basic_auth_password is defined %}
# Copy basic auth file.
COPY biostar-auth /etc/nginx/biostar-auth
RUN chown www-data:www-data /etc/nginx/biostar-auth
RUN chmod 0600 /etc/nginx/biostar-auth
{% endif %}

# Expose SSH and webserver ports.
EXPOSE 80 22

# Add the Nginx start script (executed on a `docker run`).
RUN echo '#!/bin/bash' > /etc/my_init.d/01_start_nginx.sh
RUN echo 'exec service nginx start' >> /etc/my_init.d/01_start_nginx.sh
RUN chmod +x /etc/my_init.d/01_start_nginx.sh

# Add the webapp daemon: a Runit script executed on a `docker run`.
# Runit will keep the daemon up and running, restarting it when it crashes.
RUN mkdir /etc/service/webapp
RUN ln -s {{ container_dir_for_codebase }}/run-webapp.sh /etc/service/webapp/run

# Install host's SSH public key.
RUN echo "{{ host_ssh_public_key.stdout }}" >> /root/.ssh/authorized_keys

## END CUSTOMIZATION
##################################################################################################


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


###################################################################################################
## HOW TO USE IT
#
# Build:
#     docker build -t biostar/webapp .
# Run:
#     docker run -d --link postgresql:pg -p 80:80 -p 2222:22 --volume={{ host_dir_for_codebase }}:{{ container_dir_for_codebase }} --name webapp biostar/webapp