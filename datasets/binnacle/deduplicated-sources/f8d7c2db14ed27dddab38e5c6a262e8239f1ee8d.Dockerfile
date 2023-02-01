FROM ubuntu:precise
MAINTAINER romeOz <serggalka@gmail.com>

ENV PHP_VERSION=5.3 \
	OS_LOCALE="en_US.UTF-8"
RUN locale-gen ${OS_LOCALE}
ENV LANG=${OS_LOCALE} \
    LANGUAGE=${OS_LOCALE} \
    LC_ALL=${OS_LOCALE}

# Add playbooks to the Docker image
ADD ./app /var/www/app/
ADD ./provisioning /tmp/provisioning/

COPY entrypoint.sh /sbin/entrypoint.sh

WORKDIR /tmp/provisioning/

RUN	\
	BUILD_DEPS='software-properties-common python-software-properties' \
	# Install ansible
	&& apt-get update \
	&& apt-get install --no-install-recommends -y $BUILD_DEPS sudo \
	&& add-apt-repository -y ppa:ansible/ansible \
	&& apt-get update \
	&& apt-get install -y ansible \
	# Apply playbooks
	&& ansible-playbook -v docker.yml -i 'docker,' -c local --extra-vars "php_version=${PHP_VERSION}" \
	# Cleaning
	&& apt-get purge -y --auto-remove ansible $BUILD_DEPS \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/provisioning* \
	# Forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/apache2/access.log \
	&& ln -sf /dev/stderr /var/log/apache2/error.log \
	&& chmod 755 /sbin/entrypoint.sh

WORKDIR /var/www/app/

EXPOSE 80 443

# By default, simply start apache.
CMD ["/sbin/entrypoint.sh"]