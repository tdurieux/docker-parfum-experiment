FROM {{ "ci-bullseye" | image_tag }}

USER root

# PHP is needed for the mediawiki-core job, which runs maintenance/mwdocgen.php
RUN {{ "doxygen graphviz php-cli php-intl php-mbstring php-xml" | apt_install }}

COPY run.sh /run.sh

USER nobody
WORKDIR /src
ENTRYPOINT ["/run.sh"]