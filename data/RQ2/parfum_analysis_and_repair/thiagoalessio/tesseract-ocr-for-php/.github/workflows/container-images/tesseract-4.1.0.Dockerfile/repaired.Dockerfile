FROM docker.io/library/fedora:31

RUN dnf install -y curl git php-cli php-json php-pecl-xdebug php-xml unzip \
	tesseract-4.1.0-1.fc31 \
	tesseract-langpack-deu \
	tesseract-langpack-jpn \
	tesseract-langpack-spa &&\
	dnf clean all && rm -rf /var/cache/yum && rm -rf /var/tmp/yum-*

RUN curl -f -sko- https://getcomposer.org/installer | \
	php -- --quiet --filename=composer --install-dir=/usr/local/bin

ENTRYPOINT ["/bin/bash"]
